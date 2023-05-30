#!/bin/bash

#SBATCH --job-name=python_script
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=50G
#SBATCH --time=03:00:00
#SBATCH --partition=k2-hipri
#SBATCH --output=./logs/python_script_%j.log
#SBATCH --mail-user=arios@us.es
#SBATCH --mail-type=BEGIN,END,FAIL

module add apps/anaconda3/5.2.0/bin
source ~/.bashrc
conda activate /mnt/scratch2/users/arios/conda/envs/sensory-fusion
python create_visual_frame_dataset.py