import numpy as np
from globals import *
import tensorflow as tf
import matplotlib.pyplot as plt
import os
from alive_progress import alive_bar

# Define the dataset path
DATA_PATH = "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test\\visual_test.npz"
# Load dataset
data = np.load(DATA_PATH, allow_pickle=True)
samples = data['samples']
labels = data['labels']

"""
    Function that plots all frames of sample which index is given as parameter
"""
def plot_sample(sample_idx):
    sample = samples[sample_idx]
    # sample = (sample/np.amax(sample)) * 255.0
    for frame_idx in range(0, len(sample)):
        frame = sample[frame_idx]
        plt.axis('off')
        plt.imshow(frame)
        plt.savefig(f"C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test\\sample_tests\\{labels[sample_idx]}\\plot_frame_{frame_idx}_label_{labels[sample_idx]}.jpg")

"""
    Plot the number of frames per each sample in the dataset (DATA_PATH)
"""
# Print dataset number of samples and labels
logger.info("Samples: %d", len(samples))
logger.info("Labels: %d", len(labels))
# Plot frame_lengths as plot bar
frame_lengths = [len(sample) for sample in samples]
plt.bar(range(len(frame_lengths)), frame_lengths)
plt.show()

# Get the index of the max element in the frame_lengths list
max_idx = frame_lengths.index(max(frame_lengths))
# Get the index of the min element in the frame_lengths list
min_idx = frame_lengths.index(min(frame_lengths))
# Plot the frames of the sample with the max number of frames
plot_sample(max_idx)
# Plot the frames of the sample with the min number of frames
plot_sample(min_idx)








