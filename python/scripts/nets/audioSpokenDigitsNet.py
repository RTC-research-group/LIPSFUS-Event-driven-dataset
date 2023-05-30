"""
This is a custom net for spoken digits audio classification
"""
from tensorflow.keras import layers
from globals import *
from tensorflow import keras

# NET 3
inputs = layers.Input(shape=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE), 1))
net = layers.Conv2D(100, kernel_size=(3, 3), strides=1, activation="relu")(inputs)
net = layers.MaxPooling2D(pool_size=(2, 2))(net)
net = layers.Conv2D(200, kernel_size=(2, 2), strides=1, activation="relu")(net)
net = layers.MaxPooling2D(pool_size=(2, 2))(net)
net = layers.Flatten()(net)
net = layers.Dropout(0.5)(net)
net = layers.Dense(len(SAMPLE_LABELS), activation="softmax")(net)
model = keras.Model(inputs, net)
model.summary()

# NET 2
# inputs = layers.Input(shape=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE), 1))
# net = layers.Conv2D(64, kernel_size=(3, 3), strides=1, activation="relu")(inputs)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Conv2D(128, kernel_size=(2, 2), strides=1, activation="relu")(net)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Flatten()(net)
# net = layers.Dropout(0.5)(net)
# net = layers.Dense(len(SAMPLE_LABELS), activation="softmax")(net)
# model = keras.Model(inputs, net)
# model.summary()


# NET 1
# inputs = layers.Input(shape=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE), 1))
# net = layers.Conv2D(32, kernel_size=(3, 3), strides=1, activation="relu")(inputs)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Conv2D(64, kernel_size=(3, 3), strides=1, activation="relu")(net)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Conv2D(128, kernel_size=(2, 2), strides=1, activation="relu")(net)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Flatten()(net)
# net = layers.Dropout(0.5)(net)
# net = layers.Dense(len(SAMPLE_LABELS), activation="softmax")(net)
# model = keras.Model(inputs, net)
# model.summary()

# NET 0
# inputs = layers.Input(shape=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE), 1))
# net = layers.Conv2D(32, kernel_size=(3, 3), strides=1, activation="relu")(inputs)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Conv2D(64, kernel_size=(2, 2), strides=1, activation="relu")(net)
# net = layers.MaxPooling2D(pool_size=(2, 2))(net)
# net = layers.Flatten()(net)
# net = layers.Dropout(0.5)(net)
# net = layers.Dense(len(SAMPLE_LABELS), activation="softmax")(net)
# model = keras.Model(inputs, net)
# model.summary()
