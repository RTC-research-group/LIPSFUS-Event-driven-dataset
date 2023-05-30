from pyNAVIS import *
import numpy as np
import matplotlib.pyplot as plt


def plot_sonogram(sng):
    graph_title = 'Sonogram IMG'
    plt.style.use('default')
    sng_fig = plt.figure()
    sng_fig.canvas.set_window_title(graph_title)
    plt.imshow(sng, aspect="auto", cmap='hot') #, aspect="auto") # cmap'hot'
    plt.gca().invert_yaxis()
    plt.xlabel('Bin (' + str(SETTINGS.bin_size) + '$\mu$s width)', fontsize='large')
    plt.ylabel('Address', fontsize='large')
    plt.title(graph_title, fontsize='x-large')
    colorbar = plt.colorbar()
    colorbar.set_label('No. of spikes', rotation=270, fontsize='large', labelpad= 10)
    sng_fig.show()


if __name__ == "__main__":
    # Set file path
    AEDAT_FILE_PATH = "/home/arios/Projects/sensory-fusion/ulster/datasets/bci_room/words_audio/Alejandro_0degrees_BCIroom_word_audio_Eight_th_4600_prets_100000_ts_30555117_32055117.aedat"
    # Set cut time value to extract the information from the sonogram
    CUT_TIME = 500000
    # 64 Channels,  Stereo, 16 bits address, recorded using jAER
    SETTINGS = MainSettings(num_channels=64, mono_stereo=1, on_off_both=1, address_size=2, ts_tick=1, bin_size=10000)  # 25000 propone Alex
    # Read the .aedat file and load the spikes
    spikes = Loaders.loadAEDAT(AEDAT_FILE_PATH, SETTINGS)
    # Plot spikegram
    Plots.spikegram(spikes, SETTINGS)
    # Plot sonogram
    Plots.sonogram(spikes, SETTINGS)
    # Get the first milliseconds define by cut_time of the recording
    spikes_cut = Splitters.manual_splitter(spikes, SETTINGS, 0, CUT_TIME)
    Plots.sonogram(spikes_cut, SETTINGS)
    # Get the sonogram of the cut window
    sonogram = Plots.sonogram(spikes_cut, SETTINGS, return_data=True)
    # Get left and right sonogram separately and make a new combination L|R
    sonogram_l = sonogram[:128, :40]
    sonogram_r = sonogram[128:, :40]
    sonogram_lr = np.concatenate((sonogram_l, sonogram_r), axis=1)
    plot_sonogram(sonogram_l)
    plot_sonogram(sonogram_r)
    plot_sonogram(sonogram_lr)
