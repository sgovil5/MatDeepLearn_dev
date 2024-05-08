#!/bin/bash

# export DATASET_SRC_FILE=linspace0.5_orders8_sigmas6
# sed -i "s/DATASET_SRC_FILE/$DATASET_SRC_FILE/" configs/GMP_pretraining.yml
module load python
conda activate matdeeplearn
echo pretrain_linspace2.0_orders2_sigmas4
python scripts/main.py --config_path configs/GMP_pretraining.yml --run_mode train
