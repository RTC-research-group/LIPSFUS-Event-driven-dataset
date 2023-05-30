
from globals import *
import glob
from alive_progress import alive_bar
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
import os
import tensorflow as tf
import math


# def spikes_data_augmentation(spikes):
#     """
#         Create new samples from the original one. The temporal windows is moved from init_augmented_ts to eng_augmented_ts
#         using a AUG_TIME_STEP interval time (us). Using this function we can create several samples from the original
#         one without modify the vision data, just adding noise to de beginning and the end of the audio sample
#     """
#     result = []
#     init_augmented_ts = int(0)
#     end_augmented_ts = int(spikes.timestamps[-1])
#     vision_aug_time_step = int((end_augmented_ts - VISION_AUG_TEMPORAL_WINDOW) / VISION_AUG_RATE)
#     for init_ts in range(init_augmented_ts, end_augmented_ts, vision_aug_time_step):  # Include the end of the range
#         spks = Splitters.manual_splitter(spikes, SETTINGS, init_ts, init_ts + VISION_AUG_TEMPORAL_WINDOW)
#         Functions.adapt_timestamps(spks.timestamps, SETTINGS)
#         result.append(spks)
#     return result


if __name__ == "__main__":
    logger.info("Converting .aedat files into frames (npy)...")
    # Create the lists for all samples and labels
    samples_list = []
    labels_list = []
    # Get all file paths that exist in the 'VIDEO_AEDAT_FILES_PATH' folder
    aedat_files = glob.glob(VISUAL_AEDAT_FILES_PATH + '*.aedat')
    with alive_bar(len(aedat_files)) as bar:
        for file_path in aedat_files:
            # Read the .aedat file and load the spikes
            spikes = Loaders.loadAEDAT(file_path, SETTINGS)
            # Adapt the timestamps to start in 0 sec
            Functions.adapt_timestamps(spikes.timestamps, SETTINGS)
            # Check if each timestamp is greater than its previous one
            timestamps_ok = not any(i > 0 and spikes.timestamps[i] < spikes.timestamps[i - 1]
                                    for i in range(len(spikes.timestamps)))
            if not timestamps_ok:
                logger.error("The SpikesFile file that has been loaded has at least one timestamp whose value is lesser "
                          "than its previous one.")
                exit(-1)
            
            # Create sequence of frames using a fixed number of spikes
            # Create the structure to save the histograms from aedat file.
            # Dimensions (VISION_AEDAT_HEIGHT, VISION_AEDAT_WIDTH, NUM_SPIKES/SPIKES_PER_FRAME)
            frames = [np.zeros(shape=(VISION_AEDAT_HEIGHT, VISION_AEDAT_WIDTH), dtype=np.uint16)
                        for idx in range(0, math.ceil(len(spikes.addresses)/SPIKES_PER_FRAME))]
            frame_idx = 0
            spikes_counter = 0
            for spike in spikes.addresses:
                # Get the spike coordinates
                x_coord = (spike & 0x00FE) >> 1
                y_coord = (spike & 0x7F00) >> 8
                # Accumulate the spike in the current histogram
                frames[frame_idx][y_coord, x_coord] += 1
                spikes_counter += 1
                # Check if the current frame is full
                if spikes_counter == SPIKES_PER_FRAME:
                    frame_idx += 1
                    spikes_counter = 0

            # # Old implementation
            # # Data augmentation
            # augmented_spikes_list = spikes_data_augmentation(spikes)
            # for augmented_spikes in augmented_spikes_list:
            #     # Get the slice time window limit
            #     slice_time_limit = int(spikes.timestamps[-1]/SLICES_NUMBER)
            #     # Create the structure to save the histograms from aedat file.
            #     # Dimensions (VISION_AEDAT_HEIGHT, VISION_AEDAT_WIDTH, SLICES_NUMBER)
            #     frames = [np.zeros(shape=(VISION_AEDAT_HEIGHT, VISION_AEDAT_WIDTH), dtype=np.uint8)
            #               for idx in range(0, SLICES_NUMBER)]
            #     # Loop in the aedat file and create the histograms and save them into the previous structure
            #     frame_idx = -1
            #     previous_timestamp_module = 0
            #     events_number = len(spikes.addresses)
            #     for event_idx in range(0, events_number):
            #         # Check if the current spike corresponds to the current histogram or the next one
            #         timestamp_module = spikes.timestamps[event_idx] % slice_time_limit
            #         if timestamp_module == 0 or timestamp_module < previous_timestamp_module:
            #             frame_idx += 1
            #         if frame_idx >= SLICES_NUMBER:
            #             break
            #         previous_timestamp_module = timestamp_module
            #         # Get the spike coordinates
            #         event_addr = spikes.addresses[event_idx]
            #         x_coord = (event_addr & 0x00FE) >> 1
            #         y_coord = (event_addr & 0x7F00) >> 8
            #         # Accumulate the spike in the current histogram
            #         frames[frame_idx][y_coord, x_coord] += 1
                    if DEBUG_PLOTS:
                        for frame in frames:
                            plt.axis('off')
                            plt.imshow(frames[frame_idx-1], cmap='gray')
                            plt.show()

            # Get the label of the current sample
            file_name = file_path.split("/")[-1].split(".")[0]
            label_idx = -1
            for label in SAMPLE_LABELS:
                try:
                    file_name.index(label)
                except ValueError:
                    None
                else:
                    label_idx = np.uint8(SAMPLE_LABELS.index(label))
                    break
            # Check if the label if good or not
            if label_idx == -1:
                logger.error("Incorrect label (%s) for file %s", label, file_name)
                exit(-1)
            # Append the new sample and its correspond label into the dataset lists
            samples_list.append(frames)
            labels_list.append(label_idx)
            # Update the progress bar
            bar()
        logger.info(".aedat files converted")

    # Print some information about the dataset
    logger.info("Samples: %d", len(samples_list))
    logger.info("Labels: %d", len(labels_list))
    #logger.info("Samples shape: %s", str(samples_list[0].shape))
    #logger.info("Max frames per sample: %d", np.max(np.array(samples_list).shape[1:]))
    #logger.info("Min frames per sample: %d", np.min(np.array(samples_list).shape[1:]))

    # Save the dataset into a .npy file
    logger.info("Saving the dataset into a .npy file...")
    train_elements = int(DATASET_SPLIT_DISTRIBUTION[0] * len(samples_list))
    val_elements = int(DATASET_SPLIT_DISTRIBUTION[1] * len(samples_list))
    test_elements = int(DATASET_SPLIT_DISTRIBUTION[2] * len(samples_list))

    np.savez_compressed(VISUAL_TRAIN_PATH + '/visual_train',
                        samples=samples_list[0:train_elements],
                        labels=labels_list[0:train_elements])
    np.savez_compressed(VISUAL_VAL_PATH + '/visual_val',
                        samples=samples_list[train_elements:train_elements+val_elements],
                        labels=labels_list[train_elements:train_elements+val_elements])
    np.savez_compressed(VISUAL_TEST_PATH + '/visual_test',
                        samples=samples_list[train_elements+val_elements:],
                        labels=labels_list[train_elements+val_elements:])
    logger.info("Datasets saved!")
