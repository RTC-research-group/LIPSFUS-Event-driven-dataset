#!/bin/bash

#SBATCH --job-name=NN_trainner
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=50G
#SBATCH --time=24:00:00
#SBATCH --partition=k2-medpri
#SBATCH --output=./logs/visual_NN_trainner_%j.log
#SBATCH --mail-user=arios@us.es
#SBATCH --mail-type=BEGIN,END,FAIL

module add apps/anaconda3/5.2.0/bin
source ~/.bashrc
conda activate /mnt/scratch2/users/arios/conda/envs/sensory-fusion
python3 visual_NN_classifier.py
