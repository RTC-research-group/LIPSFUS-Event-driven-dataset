# LIPSFUS-Event-driven-dataset
This repo contains the raw data recorded using jAER (https://github.com/SensorsINI/jaer) from a setup composed of two vision sensors: a DAVIS346 retina (https://shop.inivation.com/products/davis346) and a CMNDV (https://ieeexplore.ieee.org/abstract/document/6407468) retina with PAER output; and a NAS (Neuromorphic Auditory Sensor) (https://ieeexplore.ieee.org/document/7523402). The CNMDV and the NAS sensors were connected through an AER merger (https://ieeexplore.ieee.org/abstract/document/1693319) to an USBAERmini2 (https://ieeexplore.ieee.org/abstract/document/4253172) platform that allows the recoding of these raw files in jAER. The "chip" used in jAER has been "DVS128AndCochleaAMS1". The DAVIS346 were connected to the DV software through an USB3 cable. Next figure shows the setup in a noisy room.

![image](https://user-images.githubusercontent.com/15526602/149207681-b7733599-89b3-4ec5-917f-c4283c5ccfbc.png)

In this room we have recorded 22 subjects with ages from 6 to 60, both genders and 5 different nationalities. These files are in the folder "NosiyRoom".
These files can be played for visualization in jAER, or they can be loaded into MATLAB with the attached sample scripts.
In the folder 
We are now working in several SNN / CNN trainings for evaluating the goodness of this dataset, so we will come back here with more digested .aedat files once the work is finished.

We have repeated the experiment in a quiter room, designed for BCI recordings, prepared to isolate the person from external noise like building ventilation, people, traffic, etc. In this case we have recorded 21 people with ages from 25 to 60 where most of them are from Ireland.

For each subject that has participated in these recordings we prepared this list of words an a sentence:

![image](https://user-images.githubusercontent.com/15526602/149209485-aacc2221-a78e-493c-b14f-6c3063159f8d.png)

The list was recorded 5 times per subject turning the stereo microphones connected to the NAS at different angles from the face of the subject (0º, 45º, 90º, -45º and -90º).

A MATLAB script allow us to split an aedat file in two: one for visual events and one for audio events. The visual one can be observed also in jAER, and the audio one can be analysed through the NAVIS software (https://github.com/jpdominguez/NAVIS-Tool):

![image](https://user-images.githubusercontent.com/15526602/149209857-08d4e714-a7d1-4d46-abac-e664464aaa67.png)

## Citation
This project is the result of a collaboration between two labs: Robotic and Tech of Computers group, SCORE lab, ETSI-EPS, Univ. of Seville (USE); Computational Neuroscience and Neuromorphic Engineering group, Ulster University.
```
@INPROCEEDINGS{10181685,
  author={Rios-Navarro, A. and Piñero-Fuentes, E. and Canas-Moreno, S. and Javed, A. and Harkin, J. and Linares-Barranco, A.},
  booktitle={2023 IEEE International Symposium on Circuits and Systems (ISCAS)}, 
  title={LIPSFUS: A neuromorphic dataset for audio-visual sensory fusion of lip reading}, 
  year={2023},
  volume={},
  number={},
  pages={1-5},
  doi={10.1109/ISCAS46773.2023.10181685}}
```
We want to thanks the Intelligent Systems Research Center from Ulster University in Derry (Northern Ireland) for hosting us in the summer of 2021 and collaborate in this neuromorphic project.
I want to thanks also the "Salvador de Madariaga" program for senior researchers scientific visits for the finnacial support of this visit.

The team:
- Alejandro Linares-Barranco. Professor at University of Seville (alinares@atc.us.es)
- Jim Harkin. Professor at University of Ulster.
- Aqib Haved. Researcher at University of Ulster.
- Liam McDaid. Professor at University of Ulster.
- John Wade. Lecturer at University of Ulster.
- Marinus Toman. PhD student at University of Ulster.
- Antonio Ríos Navarro. Assistant Professor at University of Seivlle.
- Salvador Canas Moreno. PhD student at University of Seville. 
