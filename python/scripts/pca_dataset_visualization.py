from __future__ import print_function
import time
import numpy as np
import pandas as pd
from sklearn.datasets import fetch_openml
from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import seaborn as sns
import keras
from globals import *
from alive_progress import alive_bar

plt.rcParams.update({'font.size': 22})

# Download MNIST dataset
# mnist = fetch_openml('mnist_784', version=1, cache=True)
# X = mnist.data / 255.0  #
# y = mnist.target
# print(X.shape, y.shape)

# train_df = pd.DataFrame(X, columns=feat_cols)
# train_df['y'] = y
# train_df['label'] = train_df['y'].apply(lambda i: str(i))
# train_df['label_color'] = np.array(color_labels)[y.array.codes]
# X, y = None, None
# print('Size of the dataframe: {}'.format(train_df.shape))

# Import the training dataset
audio_generator = keras.preprocessing.image.ImageDataGenerator()  # rescale=1./255
audio_train_dataset_gen = audio_generator.flow_from_directory(AUDIO_TRAIN_PATH, shuffle=True,
                                                              target_size=(NUM_CHANNELS, int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE)),
                                                              class_mode='categorical', color_mode='grayscale',
                                                              batch_size=128)
total_images = audio_train_dataset_gen.n
steps = total_images // 128  # Batch size

# Create the pandas frames from the image data generator dataset
feat_cols = ['pixel' + str(i) for i in range(0, (NUM_CHANNELS * int(AUDIO_AUG_TEMPORAL_WINDOW / BIN_SIZE)))]
train_df = pd.DataFrame(columns=feat_cols)
y = []
logger.info(f'Converting the dataset into pandas dataframe')
with alive_bar(total_images) as bar:
    for i in range(steps):
        a, b = audio_train_dataset_gen.next()
        for b_idx in range(128):
            serie = pd.Series(a[b_idx].flatten(), train_df.columns)
            train_df = train_df.append(serie, ignore_index=True)
            # The array label has zeros values in all position except in the position
            # corresponding with the class index
            y.append(int(np.where(b[1] == 1)[0]))
            bar()

# Convert integer labels to color
color_labels = ['black', 'red', 'chocolate', 'orange', 'yellow', 'lawngreen', 'green', 'cyan',
                'blue', 'darkviolet', 'crimson']
train_df['y'] = y
train_df['label'] = train_df['y'].apply(lambda i: str(i))
train_df['label_color'] = np.array(color_labels)[train_df['y']]
X, y = None, None
logger.info(f'Size of the dataframe: {train_df.shape}')

# For reproducability of the results
np.random.seed(42)
rndperm = np.random.permutation(train_df.shape[0])

# Plots some examples from the dataset
plt.gray()
fig = plt.figure(figsize=(16, 7))
for i in range(0, 15):
    ax = fig.add_subplot(3, 5, i + 1, title="Digit: {}".format(str(train_df.loc[rndperm[i], 'label'])))
    ax.matshow(train_df.loc[rndperm[i], feat_cols].values.reshape((64, 32)).astype(float))
plt.show()

# Principal Component Analysis (PCA)
pca = PCA(n_components=3)
pca_result = pca.fit_transform(train_df[feat_cols].values)
train_df['pca-one'] = pca_result[:, 0]
train_df['pca-two'] = pca_result[:, 1]
train_df['pca-three'] = pca_result[:, 2]
logger.info(f'Explained variation per principal component: {pca.explained_variance_ratio_}')

# Plot 2D figure
plt.figure(figsize=(16, 10))
sns.scatterplot(
    x="pca-one", y="pca-two",
    hue="y",
    palette=sns.color_palette("hls", len(color_labels)),
    data=train_df.loc[rndperm, :],
    legend="full",
    alpha=0.3
)
plt.show()

# Plot 3D figure
ax = plt.figure(figsize=(16, 10)).gca(projection='3d')
ax.scatter(
    xs=train_df.loc[rndperm, :]["pca-one"],
    ys=train_df.loc[rndperm, :]["pca-two"],
    zs=train_df.loc[rndperm, :]["pca-three"],
    c=train_df.loc[rndperm, :]["label_color"],
    cmap='tab10'
)
ax.set_xlabel('pca-one')
ax.set_ylabel('pca-two')
ax.set_zlabel('pca-three')
plt.show()

# The other algorithm
N = 10000
df_subset = train_df.loc[rndperm[:N], :].copy()
data_subset = df_subset[feat_cols].values

pca = PCA(n_components=3)
pca_result = pca.fit_transform(data_subset)

df_subset['pca-one'] = pca_result[:, 0]
df_subset['pca-two'] = pca_result[:, 1]
df_subset['pca-three'] = pca_result[:, 2]
logger.info(f'Explained variation per principal component: {pca.explained_variance_ratio_}')

time_start = time.time()
tsne = TSNE(n_components=2, verbose=1, perplexity=40, n_iter=300)
tsne_results = tsne.fit_transform(data_subset)
logger.info(f't-SNE done! Time elapsed: {time.time()-time_start} seconds')

df_subset['tsne-2d-one'] = tsne_results[:, 0]
df_subset['tsne-2d-two'] = tsne_results[:, 1]
plt.figure(figsize=(16, 10))
sns.scatterplot(
    x="tsne-2d-one", y="tsne-2d-two",
    hue="y",
    palette=sns.color_palette("hls", len(color_labels)),
    data=df_subset,
    legend="full",
    alpha=0.3
)
plt.show()

pca_50 = PCA(n_components=50)
pca_result_50 = pca_50.fit_transform(data_subset)
logger.info(f'Cumulative explained variation for 50 principal components: {np.sum(pca_50.explained_variance_ratio_)}')

time_start = time.time()
tsne = TSNE(n_components=2, verbose=0, perplexity=40, n_iter=300)
tsne_pca_results = tsne.fit_transform(pca_result_50)
logger.info(f't-SNE done! Time elapsed: {time.time()-time_start} seconds')

df_subset['tsne-pca50-one'] = tsne_pca_results[:, 0]
df_subset['tsne-pca50-two'] = tsne_pca_results[:, 1]

plt.figure(figsize=(16, 4))
ax1 = plt.subplot(1, 3, 1)
sns.scatterplot(
    x="pca-one", y="pca-two",
    hue="y",
    palette=sns.color_palette("hls", len(color_labels)),
    data=df_subset,
    legend="full",
    alpha=0.3,
    ax=ax1
)
ax2 = plt.subplot(1, 3, 2)
sns.scatterplot(
    x="tsne-2d-one", y="tsne-2d-two",
    hue="y",
    palette=sns.color_palette("hls", len(color_labels)),
    data=df_subset,
    legend="full",
    alpha=0.3,
    ax=ax2
)
ax3 = plt.subplot(1, 3, 3)
sns.scatterplot(
    x="tsne-pca50-one", y="tsne-pca50-two",
    hue="y",
    palette=sns.color_palette("hls", len(color_labels)),
    data=df_subset,
    legend="full",
    alpha=0.3,
    ax=ax3
)
plt.show()
