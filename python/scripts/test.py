import numpy as np
from globals import *
import tensorflow as tf
import matplotlib.pyplot as plt
import os
from alive_progress import alive_bar
import cv2
from PIL import Image
from keras.preprocessing.image import save_img
from keras.preprocessing.image import array_to_img

"""
    Normalize the video sequence using the higher value of a frame in the sequence
"""
DATA_PATH = "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test\\visual_test.npz"

data = np.load(DATA_PATH, allow_pickle=True)
samples = data['samples']
labels = data['labels']
print(f'examples dim: dim: {samples.ndim}, shape: {samples.shape}, type: {samples.dtype}')
print(f'labels dim: {labels.ndim}, shape: {labels.shape}, type: {labels.dtype}')

logger.info("Samples: %d", len(samples))
logger.info("Labels: %d", len(labels))
# plot frame_lengths as plot bar
frame_lengths = [len(sample) for sample in samples]
plt.bar(range(len(frame_lengths)), frame_lengths)
plt.show()

plt.imshow(frame_lengths)
plt.show()
logger.info("Max frames per sample: %d", max(len(sample) for sample in samples))
logger.info("Min frames per sample: %d", min(len(sample) for sample in samples))

SAVE_PATH = "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test\\sample_tests\\"

for s_idx in range(0, len(labels)):
    sample = samples[s_idx]
    # print(f"Max sample value {np.amax(sample)}")
    sample = (sample/np.amax(sample)) * 255.0
    # print(f"Max sample value {np.amax(sample)}")
    folder = SAVE_PATH + str(labels[s_idx])
    os.makedirs(folder, exist_ok=True)
    sample_name = folder + "\\" + "s_idx_" + str(s_idx) + ".mp4"
    # video = cv2.VideoWriter(sample_name, cv2.VideoWriter_fourcc(*'mp4v'), 1, (sample.shape[2], sample.shape[1]), False)
    for frame_idx in range(0, sample.shape[0]):
        frame = sample[frame_idx]
        cv2.imwrite(folder+f"\\frame_{frame_idx}_label_{labels[s_idx]}.jpg", frame)
        plt.axis('off')
        plt.imshow(frame)
        plt.savefig(folder+f"\\plot_frame_{frame_idx}_label_{labels[s_idx]}.jpg")


# """
#     Create video (SAVE_PATH) from frame sequence of each sample of a specific dataset (DATA_PATH)
# """
# # DATA_URL = 'https://storage.googleapis.com/tensorflow/tf-keras-datasets/mnist.npz'
# # DATA_PATH = "/home/arios/Projects/sensory-fusion/ulster/datasets/bci_room/frames/visual/test/visual_test.npz"
# DATA_PATH = "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test\\visual_test.npz"

# data = np.load(DATA_PATH)
# samples = data['samples']
# labels = data['labels']
# print(f'examples dim: dim: {samples.ndim}, shape: {samples.shape}, type: {samples.dtype}')
# print(f'labels dim: {labels.ndim}, shape: {labels.shape}, type: {labels.dtype}')

# SAVE_PATH = "C:\\Users\\jario\\Projects\\sensory-fusion\\ulster\\datasets\\bci_room\\frames\\visual\\test\\sample_tests\\"
# with alive_bar(len(labels)) as bar:
#     for s_idx in range(0, len(labels)):
#         sample = samples[s_idx]
#         folder = SAVE_PATH + str(labels[s_idx])
#         os.makedirs(folder, exist_ok=True)
#         sample_name = folder + "\\" + "s_idx_" + str(s_idx) + ".mp4"
#         video = cv2.VideoWriter(sample_name, cv2.VideoWriter_fourcc(*'mp4v'), 5, (sample.shape[2], sample.shape[1]), False)
#         for frame_idx in range(0, sample.shape[0]):
#             frame = sample[frame_idx]
#             # video.write(frame)
#             # cv2.imwrite(folder+"\\frame%d.jpg" % frame_idx, frame)
#             plt.axis('off')
#             # plt.imshow(frame)
#             plt.savefig(folder+"\\frame%d.jpg" % frame_idx)
#         bar()
#         video.release()

