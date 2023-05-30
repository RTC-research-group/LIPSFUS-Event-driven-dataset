from tensorflow import keras
from globals import *
import matplotlib.pyplot as plt
import os
from sklearn.utils import class_weight
import numpy as np
from collections import Counter
import tensorflow as tf


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
    plt.savefig(AUDIO_MODEL_TRAINED_PATH + '_' + str(TRAINING_EPOCHS) + '_epochs_' + str(LEARNING_RATE) + '_lr_'
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
    plt.savefig(AUDIO_MODEL_TRAINED_PATH + '_' + str(TRAINING_EPOCHS) + '_epochs_' + str(LEARNING_RATE) + '_lr_'
                + str(BATCH_SIZE) +'_batchSize/loss.jpeg')


if __name__ == "__main__":
    # Force keras to user GPU or CPU
    os.environ['CUDA_VISIBLE_DEVICES'] = '-1'  # Comment this line to use keras GPU
    # List CUDA devices
    # tf.config.list_physical_devices('GPU')
    # Force to create TF_XLA_FLAGS (optional)
    # os.environ['TF_XLA_FLAGS'] = '--tf_xla_enable_xla_devices'
    # Set tenforflow to be launched in GPUs that are shared for several users
    # gpus = tf.config.experimental.list_physical_devices('GPU')
    # for gpu in gpus:
    #     tf.config.experimental.set_memory_growth(gpu, True)
    # Create keras dataset
    audio_generator = keras.preprocessing.image.ImageDataGenerator()  # rescale=1./255
    logger.info("Creating and loading audio datasets (train, validation and test)...")
    audio_train_dataset_gen = audio_generator.flow_from_directory(AUDIO_TRAIN_PATH, shuffle=True,
                                                                  target_size=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE)),
                                                                  class_mode='categorical', color_mode='grayscale',
                                                                  batch_size=BATCH_SIZE)
    audio_val_dataset_gen = audio_generator.flow_from_directory(AUDIO_VAL_PATH, shuffle=True,
                                                                target_size=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE)),
                                                                class_mode='categorical', color_mode='grayscale',
                                                                batch_size=BATCH_SIZE)
    audio_test_dataset_gen = audio_generator.flow_from_directory(AUDIO_TEST_PATH, shuffle=False,
                                                                 target_size=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE)),
                                                                 class_mode='categorical', color_mode='grayscale',
                                                                 batch_size=BATCH_SIZE)
    logger.info("Audio dataset created and loaded: Train %d, Val %d, Test %d", audio_train_dataset_gen.samples,
                audio_val_dataset_gen.samples, audio_test_dataset_gen.samples)

    logger.info("Checking the class balance in the dataset...")
    logger.info(f'Classes index coding: {audio_train_dataset_gen.class_indices}')
    class_num_samples = Counter(audio_train_dataset_gen.classes)
    logger.info(f'Number of samples per class {class_num_samples.items()}')
    class_weights = class_weight.compute_class_weight('balanced', classes=np.unique(audio_train_dataset_gen.classes),
                                                      y=audio_train_dataset_gen.classes)
    class_weights_dict = dict(enumerate(class_weights))
    logger.info(f'Class weights: {class_weights_dict}')

    model_save_path = AUDIO_MODEL_TRAINED_PATH + '_' + str(TRAINING_EPOCHS) + '_epochs_' + str(LEARNING_RATE) + '_lr_' + str(BATCH_SIZE) + '_batchSize'

    if not ALREADY_TRAINED:
        # Network defined into nets folder
        from nets.audioSpokenDigitsNet import *

        # from keras.applications import mobilenet
        # model = mobilenet.MobileNet(input_shape=(NUM_CHANNELS, int(AUG_TEMPORAL_WINDOW / BIN_SIZE), 1), classes=11,
        #                             weights=None)

        optimizer = keras.optimizers.Adam(learning_rate=LEARNING_RATE)
        model.compile(optimizer=optimizer, loss='categorical_crossentropy', metrics=['accuracy'])

        # Launch the training process
        history = model.fit(audio_train_dataset_gen, epochs=TRAINING_EPOCHS, validation_data=audio_val_dataset_gen,
                            batch_size=BATCH_SIZE, class_weight=class_weights_dict)
        # Save the model
        model.save(model_save_path)
        # Plot de results
        plot_training_metrics(history)

    else:
        # Load the model
        model = keras.models.load_model(model_save_path)
        model.summary()

    # Evaluate the model
    score = model.evaluate(audio_test_dataset_gen, verbose=0)
    logger.info(f'Test loss: {score[0]}')
    logger.info(f'Test accuracy: {score[1]}')
