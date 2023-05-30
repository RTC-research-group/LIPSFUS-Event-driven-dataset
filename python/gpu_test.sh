#!/bin/bash
#SBATCH --job-name=audio_CNN_keras
#SBATCH --time=3-00:00:00
#SBATCH -n 8
#SBATCH -p k2-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=100G
#SBATCH --output=audio_CNN_keras_%j.log

module add libs/nvidia-cuda/11.0.3/bin
module add apps/anaconda3/5.2.0/bin
conda activate /mnt/scratch2/users/arios/conda/envs/sensory-fusion
nvidia-smi
python3 audio_NN_classifier.py
