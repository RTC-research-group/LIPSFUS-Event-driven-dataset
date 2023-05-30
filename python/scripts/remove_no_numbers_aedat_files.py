import glob
import os
import logging as log
from alive_progress import alive_bar
from globals import *

if __name__ == "__main__":
    # List all aedat files
    aedat_files = glob.glob(VISUAL_AEDAT_FILES_PATH + "*.aedat")
    # Count the number of removed files
    removed_files_num = 0
    with alive_bar(len(aedat_files)) as bar:
        log.info(f'Number of aedat files: {len(aedat_files)}')
        for file_path in aedat_files:
            file_name = file_path.split("/")[-1]
            label_idx = -1
            for label in SAMPLE_LABELS:
                try:
                    file_name.index(label)
                except ValueError:
                    None
                else:
                    label_idx = SAMPLE_LABELS.index(label)
                    break
            if label_idx == -1:
                os.remove(file_path)
                removed_files_num += 1
            bar()
    log.warning(f'Number of removed files: {removed_files_num}')
    num_spoken_digits_files = len(aedat_files)-removed_files_num
    log.info(f'Number of spoken digits .aedat files: {num_spoken_digits_files}')
    log.info(f'Number of persons (aprox) in the dataset [num_files/(5_orientations*11_spoken_digits)]: '
             f'{num_spoken_digits_files/(5*11)}')
