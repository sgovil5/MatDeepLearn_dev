#!/bin/bash

# export DATASET_SRC_FILE=linspace${linspace}_orders${orders}_sigmas${sigmas}${scale}
# sed -i "s/DATASET_SRC_FILE/$DATASET_SRC_FILE/" configs/GMP_pretraining.yml
module load python
conda activate matdeeplearn
# echo pretrain_linspace2.0_orders8_sigmas6
python scripts/main.py --config_path configs/GMP_pretraining.yml --run_mode train
