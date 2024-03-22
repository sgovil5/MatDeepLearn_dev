#!/bin/bash

#SBATCH -J pretrain_linspace1_orders8_sigmas6  # Job name
#SBATCH -A gts-vfung3                        # Charge account
#SBATCH -N1 --gres=gpu:A100:1                # Number of nodes and GPUs required
#SBATCH --mem-per-gpu=64G                    # Memory per gpu
#SBATCH -t36:00:00                          # Duration of the job (Ex: 15 mins)
#SBATCH -qinferno                            # QOS name
#SBATCH -o featurizer_results/pretrain/linspace1_orders8_sigmas6.out               # Combined output and error messages file
#SBATCH --mail-type=BEGIN,END,FAIL           # Mail preferences
#SBATCH --mail-user=sgovil9@gatech.edu           # e-mail address for notifications

export DATASET_SRC_FILE=linspace1_orders8_sigmas6
sed -i "s/DATASET_SRC_FILE/$DATASET_SRC_FILE/" configs/GMP_pretraining.yml
module load anaconda3
conda activate my_mdl_env
echo pretrain_linspace1_orders8_sigmas6
python scripts/main.py --config_path configs/GMP_pretraining.yml --run_mode train
