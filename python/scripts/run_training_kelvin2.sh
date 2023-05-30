#!/bin/bash
#SBATCH --job-name=04
#SBATCH --time=3-00:00:00
#SBATCH -n 8
#SBATCH -p k2-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=500G

module add libs/nvidia-cuda/11.0.3/bin

nvidia-smi

python3 audio_NN_classifier.py
