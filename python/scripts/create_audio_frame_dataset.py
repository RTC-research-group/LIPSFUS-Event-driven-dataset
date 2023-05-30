
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import glob
from alive_progress import alive_bar
from datetime import datetime
import os
from globals import *


def plot_sonogram(sonogram, graph_title='Sonogram IMG'):
    """
        Plots the sonogram using a hot map
    """
    plt.style.use('default')
    sng_fig = plt.figure()
    sng_fig.canvas.set_window_title(graph_title)
    plt.imshow(sonogram, aspect="auto", cmap='gray') #, aspect="auto") # cmap'hot'
    plt.gca().invert_yaxis()
    plt.xlabel('Bin (' + str(SETTINGS.bin_size) + '$\mu$s width)', fontsize='large')
    plt.ylabel('Address', fontsize='large')
    plt.title(graph_title, fontsize='x-large')
    colorbar = plt.colorbar()
    colorbar.set_label('No. of spikes', rotation=270, fontsize='large', labelpad= 10)
    sng_fig.show()


def spikes_data_augmentation(spikes):
    """
        Create new samples from the original one. The temporal windows is moved from init_augmented_ts to eng_augmented_ts
        using a TIME_STEP interval time. Using this function we can create several samples from the original one without
        modify the audio, just adding noise to de beginning and the end of the audio sample
    """
    result = []
    init_augmented_ts = int((CUT_TIME_WINDOW / 2) - (AUDIO_AUG_TEMPORAL_WINDOW / 2) - (AUDIO_AUG_TIME_STEP * (AUDIO_AUG_RATE / 2)))
    end_augmented_ts = int((CUT_TIME_WINDOW / 2) - (AUDIO_AUG_TEMPORAL_WINDOW / 2) + (AUDIO_AUG_TIME_STEP * (AUDIO_AUG_RATE / 2)))
    for init_ts in range(init_augmented_ts, (end_augmented_ts + AUDIO_AUG_TIME_STEP), AUDIO_AUG_TIME_STEP):  # Include the end of the range
        result.append(Splitters.manual_splitter(spikes, SETTINGS, init_ts, init_ts + AUDIO_AUG_TEMPORAL_WINDOW))
    return result


def combine_positive_negative_spikes(sng):
    """
        Combine the positive and negative channel information only in one value. So positive and negative spikes are used
        with no signed. E.g.: If the cochlea has 64 channels, the sonogram has 128 rows, so the rows must be combined two
        by two. Row 0 and 1, row 2 and 3, row 4 and 5, ... resulting a sonogram of 64 rows.
    """
    rows_num = len(sng[:, 0])
    reduced_sng = np.vstack([np.sum(sng[[r_idx, r_idx+1], :], 0) for r_idx in range(0, rows_num-1, 2)])
    return reduced_sng


if __name__ == "__main__":
    log.info("Converting .aedat files into frames...")
    # Get all file paths that exist in the 'AUDIO_AEDAT_FILES_PATH' folder
    aedat_files = glob.glob(AUDIO_AEDAT_FILES_PATH + '*.aedat')
    with alive_bar(len(aedat_files)) as bar:
        for file_path in aedat_files:
            # Read the .aedat file and load the spikes
            spikes = Loaders.loadAEDAT(file_path, SETTINGS)
            if DEBUG_PLOTS:
                Plots.spikegram(spikes, settings=SETTINGS)
            # Check if the spikes file is good
            # Functions.check_SpikesFile(spikes, settings)
            # Cut the original sample getting the first milliseconds define by cut_time of the recording
            spikes_cut = Splitters.manual_splitter(spikes, SETTINGS, INIT_CUT_TIME, END_CUT_TIME)
            if DEBUG_PLOTS:
                Plots.spikegram(spikes_cut, settings=SETTINGS)
            augmented_spikes_list = spikes_data_augmentation(spikes_cut)
            for augmented_spikes in augmented_spikes_list:
                if DEBUG_PLOTS:
                    Plots.spikegram(augmented_spikes, settings=SETTINGS)
                # Get the sonogram of the augmented spikes
                sonogram = Plots.sonogram(augmented_spikes, SETTINGS, return_data=True)
                if DEBUG_PLOTS:
                    plot_sonogram(sonogram, graph_title='Original SNG')
                # Get left and right sonogram separately and make a new combination L|R
                sonogram_l = sonogram[:128, :]
                sonogram_r = sonogram[128:, :]
                sonogram_lr = np.concatenate((sonogram_l, sonogram_r), axis=1)
                sonograms = [sonogram_l, sonogram_r, sonogram_lr]
                # Get the label of the current sample
                file_name = file_path.split("/")[-1]
                label_idx = -1
                for label in SAMPLE_LABELS:
                    try:
                        file_name.index(label)
                    except ValueError:
                        None
                    else:
                        label_idx = SAMPLE_LABELS.index(label)
                        break
                # Check if the label if good or not
                if label_idx == -1:
                    log.error("Incorrect label (%s) for file %s", label, file_name)
                    exit(-1)
                # Normalize the each sonogram and save the resulting image in the right path. Left and right in mono,
                # and L|R in stereo path
                sng_idx = 0
                for sng in sonograms:
                    if DEBUG_PLOTS:
                        plot_sonogram(sng, graph_title='Split SNG')
                    # Check the spikes sign interpretation
                    if COMBINE_POSITIVE_NEGATIVE_SPIKES:
                        sng = combine_positive_negative_spikes(sng)
                        if DEBUG_PLOTS:
                            plot_sonogram(sng, graph_title='Split SNG with P_N Combined')
                    # Normalize
                    # sng_to_save = s / np.linalg.norm(s)
                    # Flip and concert to uint 8bits to save in the proper orientation and data format
                    sng = np.flip(sng, axis=0)
                    sng = sng.astype(np.uint8)
                    sonogram_img = Image.fromarray(sng, mode='L')
                    # Save all images in train folder
                    dataset_mode = 'train/'
                    if sng_idx == 2:  # Index of sonogram_lr in sonograms list
                        sonogram_img.save(SAVE_AUDIO_FRAMES_PATH + 'stereo/' + dataset_mode + SAMPLE_LABELS[label_idx] + '/'
                                          + str(datetime.now()) + AUDIO_IMAGE_FILE_EXTENSION, format='png')
                    else:
                        sonogram_img.save(SAVE_AUDIO_FRAMES_PATH + 'mono/' + dataset_mode + SAMPLE_LABELS[label_idx] + '/'
                                          + str(datetime.now()) + AUDIO_IMAGE_FILE_EXTENSION, format='png')
                    sng_idx += 1
            # Update the progress bar
            bar()
    log.info(".aedat files converted")

    # Split the samples saved into tran folder into val and test folders
    cochlea_modes = ['mono', 'stereo']
    for cochlea_mode in cochlea_modes:
        log.info("Split all frames saved in the train folder into 'val' and 'test' folders for %s cochlea mode", cochlea_mode)
        # All images were saved into train folder. Now read all images and move some of them into val and test folders
        dataset_mode = 'train/'
        labels_folder = os.listdir(SAVE_AUDIO_FRAMES_PATH + '/' + cochlea_mode + '/' + dataset_mode)
        with alive_bar(len(labels_folder)) as bar:
            for label in labels_folder:
                # List all images of each label folder from train and split them into val and test folders
                dataset_mode = 'train/'
                image_files = glob.glob(SAVE_AUDIO_FRAMES_PATH + cochlea_mode + '/' + dataset_mode + label + '/*' + AUDIO_IMAGE_FILE_EXTENSION)
                # Move the first files to val folder
                dataset_mode = 'val/'
                val_samples = int(len(image_files) * DATASET_SPLIT_DISTRIBUTION[1])
                for v_idx in range(0, val_samples):
                    file_name = image_files[v_idx].split('/')[-1]
                    os.rename(image_files[v_idx], SAVE_AUDIO_FRAMES_PATH + cochlea_mode + '/' + dataset_mode + label + '/' + file_name)
                # Move the last files to test folder
                dataset_mode = 'test/'
                test_samples = int(len(image_files) * DATASET_SPLIT_DISTRIBUTION[2])
                for t_idx in range(-1, -(test_samples+1), -1):
                    file_name = image_files[t_idx].split('/')[-1]
                    os.rename(image_files[t_idx], SAVE_AUDIO_FRAMES_PATH + cochlea_mode + '/' + dataset_mode + label + '/' + file_name)
                bar()
