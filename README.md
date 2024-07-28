# TMNRED Dataset - Chinese Natural Reading EEG for Fuzzy Semantic Target Identification

## Overview
This dataset, named TMNRED, consists of electroencephalogram (EEG) recordings obtained from 30 participants engaged in natural reading tasks. The aim is to investigate the mechanisms of semantic processing in the Chinese language within a natural reading environment.

## Data Collection
- Participants: 30 healthy, right-handed individuals (average age: 22.07 years, standard deviation: 2.7 years; 18 females, 12 males) who are native Chinese speakers.
- Materials: Text ranging from 15 to 20 characters, presented as news headlines or short sentences. Materials include target semantic items and non-target semantic items.
- Procedure: Participants read sentences displayed on a screen at their own pace. Each participant completed 8 blocks of 400 trials in total, with each trial lasting approximately 2.2 seconds, including a fixation cross and inter-stimulus intervals.

## Data Structure
The dataset is organized according to the BIDS standard:
- **Main Folder**:
  - `dataset_description.json`: Description of the dataset.
  - `participants.tsv`: Participant information.
  - `participants.json`: Details of columns in `participants.tsv`.
  - `README`: General information about the dataset.
  - `data_all.mat`: Labeled EEG data of all subjects in MAT format.
- **Derivative Data**:
  - `final_bids/`: EEG data stored in JSON, TSV, and EDF formats.
  - `preproc/`: Preprocessed data, including subfolders for each subject (`sub-01`, etc.), with data in various formats (BDF, SET, FDT, ERP, MAT).

## Technical Validation
Sensor-level EEG analyses were performed, showing distinct responses to target and non-target words at different time points, with notable changes in potential distribution across the scalp.

## Distribution
The raw and preprocessed EEG data are openly available online at https://doi.org/10.18112/openneuro.ds005383.v1.0.0 under the Creative Commons Attribution 4.0 International Public License (https://creativecommons.org/licenses/by/4.0/).

## Usage Notes
- Researchers should cite the dataset appropriately when using it.
- For any questions or issues, please refer to the `README` file or contact the corresponding authors: Yanru Bai (yr56_bai@tju.edu.cn), Guangjian Ni (niguangjian@tju.edu.cn).

## Version
braindecode==0.4.85
einops
mne
nilearn==0.9.2
ptwt==0.1.7
scikit-learn==1.2.1
scipy
torch==2.1.0
wandb
