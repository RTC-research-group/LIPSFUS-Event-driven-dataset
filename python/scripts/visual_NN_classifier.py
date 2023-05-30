import os
import numpy as np
from globals import *
import glob
import tensorflow as tf
from sklearn.utils import class_weight
from collections import Counter
import matplotlib.pyplot as plt
from tensorflow import keras

def plot_training_metrics(history_metrics):
    """
    Plot all metrics selected in the training process
    :param history_metrics: Training metrics
    :return:
    """
    # summarize history for accuracy
    plt.plot(history_metrics.history['accuracy'])
    plt.plot(history_metrics.history['val_accuracy'])
    plt.title('model accuracy')
    plt.ylabel('accuracy')
    plt.xlabel('epoch')
    plt.legend(['train', 'validation'], loc='upper left')
    plt.savefig(VISUAL_MODEL_TRAINED_PATH + '_' + str(TRAINING_EPOCHS) + '_epochs_' + str(LEARNING_RATE) + '_lr_'
                + str(BATCH_SIZE) +'_batchSize/accuracy.jpeg')
    # Clear the figure
    plt.clf()
    # summarize history for loss
    plt.plot(history_metrics.history['loss'])
    plt.plot(history_metrics.history['val_loss'])
    plt.title('model loss')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'validation'], loc='upper left')
    plt.savefig(VISUAL_MODEL_TRAINED_PATH + '_' + str(TRAINING_EPOCHS) + '_epochs_' + str(LEARNING_RATE) + '_lr_'
                + str(BATCH_SIZE) +'_batchSize/loss.jpeg')


if __name__ == "__main__":
    # Force keras to user GPU or CPU
    # os.environ['CUDA_VISIBLE_DEVICES'] = '-1'  # Comment this line to use keras GPU

    # Create keras datasets
    datasets = []
    dataset_paths = [VISUAL_TRAIN_PATH, VISUAL_VAL_PATH, VISUAL_TEST_PATH]
    for d_path in dataset_paths:
        # Load the current dataset and print some information
        logger.info(f"Loading {d_path} dataset...")
        file_npz = glob.glob(d_path + '/*.npz')
        data = np.load(file_npz[0])
        data_samples = data['samples']
        data_labels = data['labels']
        logger.info(f'data_examples dim: {data_samples.ndim}, shape: {data_samples.shape}, type: {data_samples.dtype}')
        logger.info(f'data_labels dim: {data_labels.ndim}, shape: {data_labels.shape}, type: {data_labels.dtype}')
        
        # Adap the label data to be integer in order to use Sparse Categorical Crossentropy loss function.
        logger.info(f'Adapting data...')
        if data_labels.dtype != 'uint8':
            data_labels = data_labels.astype('uint8')
        if data_samples.shape[1] == SLICES_NUMBER:
            data_samples = np.moveaxis(data['samples'], 1, -1)
        # Normalize the samples dataset using max value normalization between 0 - 1 floating point values.
        # for s_idx in range(0, data_samples.shape[0]):
        #     data_samples[s_idx] = data_samples[s_idx].astype('float32')
        #     data_samples[s_idx] = (data_samples[s_idx]/np.amax(data_samples[s_idx]))

        logger.info(f'data_examples dim: {data_samples.ndim}, shape: {data_samples.shape}, type: {data_samples.dtype}')
        logger.info(f'data_labels dim: {data_labels.ndim}, shape: {data_labels.shape}, type: {data_labels.dtype}')
        
        datasets.append(data_samples)
        datasets.append(data_labels)
        
        if d_path == VISUAL_TRAIN_PATH:
            # Balance the train dataset for better training
            logger.info("Checking the class balance in the dataset...")
            class_num_samples = Counter(data_labels)
            logger.info(f'Number of samples per class {class_num_samples.items()}')
            class_weights = class_weight.compute_class_weight('balanced', classes=SAMPLE_LABELS_INT, y=data_labels)
            class_weights_dict = dict(enumerate(class_weights))
            logger.info(f'Class weights: {class_weights_dict}')
        # logger.info(f"{d_path} has been created.")

    logger.info(f"Visual dataset created and loaded: TRAIN samples {datasets[0].shape}, labels {datasets[1].shape} - "
                f"VAL samples {datasets[2].shape}, labels {datasets[3].shape} - "
                f"TEST samples {datasets[4].shape}, labels {datasets[5].shape}")

    model_save_path = VISUAL_MODEL_TRAINED_PATH + '_' + str(TRAINING_EPOCHS) + '_epochs_' + str(LEARNING_RATE) + \
                      '_lr_' + str(BATCH_SIZE) + '_batchSize'

    if not ALREADY_TRAINED:
        # Network defined into nets folder
        from nets.visualSpokenDigitsNet import *

        # Define the training hiperparameters
        optimizer = keras.optimizers.Adam(learning_rate=LEARNING_RATE)
        loss = tf.keras.losses.SparseCategoricalCrossentropy()
        model.compile(optimizer=optimizer, loss=loss, metrics=['accuracy'])

        # Launch the training process
        history = model.fit(x=datasets[0], y=datasets[1], epochs=TRAINING_EPOCHS, batch_size=BATCH_SIZE,
                            validation_data=(datasets[2], datasets[3]), validation_batch_size=BATCH_SIZE,
                            class_weight=class_weights_dict)
        # Save the model
        model.save(model_save_path)
        # Plot de results
        plot_training_metrics(history)

    else:
        # Load the model
        model = keras.models.load_model(model_save_path)
        model.summary()

    # Evaluate the model
    score = model.evaluate(x=datasets[4], y=datasets[5], verbose=0)
    logger.info(f'Test loss: {score[0]}')
    logger.info(f'Test accuracy: {score[1]}')
