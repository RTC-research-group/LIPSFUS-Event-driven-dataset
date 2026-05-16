# AEDAT Word Spoken Extractor & Fusion Processor

This repository contains MATLAB utilities designed to process neuromorphic data in Address Event Representation (AER) formats (`.aedat` files). Specifically, the core script fragments a continuous recording session into isolated subfiles containing spoken words. It splits the recording into separate streams for audio information, visual information, and a combined multimodal fusion configuration.

The tool leverages event-driven temporal clustering to identify active word intervals based on spiking thresholds from an artificial cochlea sensor (e.g., Neuromorphic Auditory Sensor - NAS output), preparing datasets seamlessly for Spiking Neural Network (SNN) training.

---

## Features

- **Automated Spoken Word Detection**: Analyzes global cochlear event-rate spikes using custom sliding or fixed time-bins (40ms) to mark isolated word boundaries.
- **Multimodal Stream Splitting**: Splits a single compound `.aedat` file into three distinct event categories:
  - **Audio Only**: Filters out and isolates neuromorphic auditory sensor (`coch`) spikes.
  - **Visual Only**: Filters out and isolates retina sensor (`ret`) events.
  - **Fusion**: Combines synchronized audio and visual sensor streams into integrated sub-segments.
- **Dual Format Exporting**: Saves isolated word outputs both as standard neuromorphic `.aedat` files and as readable `.csv` matrices.
- **Histogram Feature Generation**: Automatically outputs frequency histograms of activated addresses per word sample to ease feature extraction pipelines.
- **Diagnostic Plot Visualization**: Automatically plots and exports spike-rate timelines with blue/black vertical lines overlaying detected phrase boundaries for rapid visual calibration.

---

## Vocabulary / Label Mapping

The processing matrix automatically tracks and maps chronological speech bursts against a standard 40-word dictionary grid. The internal matching array accommodates the following vocabulary tokens:

| Index Range | Word Labels |
| :--- | :--- |
| **1 – 10** | `one`, `two`, `three`, `four`, `five`, `Six`, `Seven`, `Eight`, `Nine`, `Zero` |
| **11 – 21** | `Oh`, `Yes`, `No`, `Up`, `Down`, `Left`, `Right`, `On`, `Off`, `Stop`, `Go` |
| **22 – 31** | `Bed`, `Bird`, `Cat`, `Dog`, `Happy`, `House`, `Marvin`, `Sheila`, `Tree`, `Wow` |
| **32 – 39** | `About`, `Border`, `Forward`, `Missing`, `Press`, `Short`, `Threat`, `Young` |
| **40** | `FoxDog sentence` |

---

## Technical Architecture & Core Logic

1. **Address Space Segmentation**:
   - Audio events (`inaddr > 32767`) are mapped to the cochlear space (`coch`).
   - Visual events (`inaddr < 32768`) are mapped to the retinal space (`ret`).
2. **Activity Evaluation Loop**:
   - The script tallies cumulative audio spikes over a sliding time-window of `40,000` microseconds (40ms).
   - If the spike count inside a block exceeds the user-specified `threshold`, and a minimum blanking window of `750,000` microseconds (0.75s) has passed since the last detected word, a speech segment start boundary is triggered.
3. **Temporal Shifting**:
   - To avoid losing the initial transient onsets of a spoken word due to processing lag, the start of the split chunk is back-shifted by a user-defined interval (`shift_earlier`).
4. **Dynamic Word Skipping**:
   - If large silent intervals are encountered between adjacent bursts, the word index counter (`w`) increments proportionally to align subsequent phrases with the expected word index position.

---

## Directory Structure

Upon execution, the script verifies and initializes the following organized folder structure within your workspace to isolate output types:

```text
├── words_fusion/         # Synchronized audio-visual .aedat sub-files and diagnostic plots
├── CSVwords_fusion/      # Compressed event time-series and address histograms (.csv) for fusion
├── words_audio/          # Audio-only .aedat sub-files and diagnostics
├── CSVwords_audio/       # Compressed event time-series and address histograms (.csv) for audio
├── words_visual/         # Retina-only .aedat sub-files and diagnostics
└── CSVwords_visual/      # Compressed event time-series and address histograms (.csv) for visual