#!/bin/bash

#SBATCH --job-name=matlab_SNN
#SBATCH -N 1
#SBATCH -n 100
#SBATCH --mem=100G
#SBATCH --time=00:25:00
#SBATCH --partition=k2-hipri
#SBATCH --output=matlab_SNN_%j.log

module load matlab/R2020b

export MLM_LICENSE_FILE=27000@193.61.190.229
export LM_LICENSE_FILE=27000@193.61.190.229

matlab -nosplash -nodisplay -r demo_buffer_cascade_lips_audio_17people
