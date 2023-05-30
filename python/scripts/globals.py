"""
This file contains all global variables for the scripts
"""
from pyNAVIS import *
import logging as log

# Define log struct
log.basicConfig(
    level=log.INFO,
    format="%(asctime)s [%(levelname)8.8s] %(message)s",
    handlers=[log.StreamHandler()],
)
logger = log.getLogger(__name__)

# 64 Channels,  Stereo, 16 bits address, recorded using jAER
NUM_CHANNELS = 64
BIN_SIZE = 20000
SETTINGS = MainSettings(num_channels=NUM_CHANNELS, mono_stereo=1, on_off_both=1, address_size=2, ts_tick=1,
                        bin_size=BIN_SIZE)
# Set the aedat path folders
AUDIO_AEDAT_FILES_PATH = "/home/arios/Projects/sensory-fusion/ulster/datasets/bci_room/words_audio/" # "/mnt/scratch2/users/arios/datasets/bci_room/words_audio/"
VISUAL_AEDAT_FILES_PATH = "/mnt/scratch2/users/arios/datasets/bci_room/words_visual/" # "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\words_visual\\"
# Define the dataset labels
SAMPLE_LABELS = ['Zero', 'one', 'two', 'three', 'four', 'five', 'Six', 'Seven', 'Eight', 'Nine', 'Oh']
SAMPLE_LABELS_INT = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# Set the paths of the resulting folders
SAVE_AUDIO_FRAMES_PATH = '..datasets/bci_room/frames/audio/'
SAVE_VISUAL_FRAMES_PATH = '..\\datasets\\bci_room\\frames\\visual\\'
# Set cut time and middle cut time (us) to extract the information from the audio sonogram
CUT_TIME_WINDOW = 700000
SOUND_MIDDLE_TIME = 650000  # Specify the center of the word sound
INIT_CUT_TIME = SOUND_MIDDLE_TIME - (CUT_TIME_WINDOW / 2)
END_CUT_TIME = SOUND_MIDDLE_TIME + (CUT_TIME_WINDOW / 2)
# Set positive and negative spikes interpretation. True means positive and negative spikes of each channel meas the same
COMBINE_POSITIVE_NEGATIVE_SPIKES = True
# Set debugging plot flag
DEBUG_PLOTS = False
# Set dataset split distribution [train, val, test]
DATASET_SPLIT_DISTRIBUTION = [0.7, 0.2, 0.1]
# For data augmentation we'll get the spikes from a temporal moving windows that collect the information of the word and
# some noise at the beginning and at the end: To do this we need to define the temporal window(us) and the timestep(us)
AUDIO_AUG_TEMPORAL_WINDOW = 650000
AUDIO_AUG_TIME_STEP = 10000
AUDIO_AUG_RATE = 10
# Set audio and visual data format extension
AUDIO_IMAGE_FILE_EXTENSION = '.png'
VISUAL_IMAGE_FILE_EXTENSION = '.npy'
# Set physical frame dataset paths
AUDIO_TRAIN_PATH = "/home/arios/Projects/sensory-fusion/ulster/datasets/bci_room/frames/audio/mono/train"  # "/mnt/scratch2/users/arios/datasets/bci_room/frames/audio/mono/train"
AUDIO_VAL_PATH = "/home/arios/Projects/sensory-fusion/ulster/datasets/bci_room/frames/audio/mono/val"  # "/mnt/scratch2/users/arios/datasets/bci_room/frames/audio/mono/val"
AUDIO_TEST_PATH = "/home/arios/Projects/sensory-fusion/ulster/datasets/bci_room/frames/audio/mono/test"  # "/mnt/scratch2/users/arios/datasets/bci_room/frames/audio/mono/test"
VISUAL_TRAIN_PATH = "/mnt/scratch2/users/arios/datasets/bci_room/frames/visual/train" # "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\train"
VISUAL_VAL_PATH = "/mnt/scratch2/users/arios/datasets/bci_room/frames/visual/val" # "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\val" 
VISUAL_TEST_PATH = "/mnt/scratch2/users/arios/datasets/bci_room/frames/visual/test" # "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test"
# Set the network status: Trained or not trained
ALREADY_TRAINED = False  # False -> the model will be trained, True -> the model will be loaded from a file
# Set number of epochs, the learning rate and batch_size
TRAINING_EPOCHS = 200
LEARNING_RATE = 0.001
BATCH_SIZE = 32
# Define the paths to save the trained network models
AUDIO_MODEL_TRAINED_PATH = 'saved_keras_models/only_audio_net'
VISUAL_MODEL_TRAINED_PATH = 'saved_keras_models/only_video_net'

# Set the number of slices for the visual data
SPIKES_PER_FRAME = 2000
SLICES_NUMBER = 6
# Vision aedat dimensions
VISION_AEDAT_WIDTH = 49
VISION_AEDAT_HEIGHT = 33
# For data augmentation we'll get the spikes from a temporal moving windows that collect the information of the word and
# some noise at the beginning and at the end: To do this we need to define the temporal window(us) and the timestep(us)
# VISION_AUG_TEMPORAL_WINDOW = 1300000
# VISION_AUG_RATE = 10
