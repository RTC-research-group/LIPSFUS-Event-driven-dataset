#!/bin/bash
#SBATCH --job-name=NN_trainner
#SBATCH --time=0-10:00:00
#SBATCH -n 12
#SBATCH -p k2-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=50G
#SBATCH --output=./logs/visual_NN_trainner_%j.log
#SBATCH --mail-user=arios@us.es
#SBATCH --mail-type=BEGIN,END,FAIL

module add libs/nvidia-cuda/11.0.3/bin
module add apps/anaconda3/5.2.0/bin
source ~/.bashrc
conda activate /mnt/scratch2/users/arios/conda/envs/sensory-fusion
nvidia-smi
python visual_NN_classifier.py
