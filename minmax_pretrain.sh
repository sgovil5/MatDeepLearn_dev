#!/bin/bash

export DATASET_SRC_FILE=linspace0.5_orders8_sigmas6_minmax
sed -i "s/DATASET_SRC_FILE/$DATASET_SRC_FILE/" configs/GMP_pretraining.yml
module load python
conda activate matdeeplearn
echo pretrain_linspace0.5_orders8_sigmas6_minmax
python scripts/main.py --config_path configs/GMP_pretraining.yml --run_mode train
