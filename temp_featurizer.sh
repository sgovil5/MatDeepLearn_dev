#!/bin/bash

#SBATCH -J linspace_orders_sigmas   # Job name
#SBATCH -A gts-vfung3                        # Charge account
#SBATCH -t24:00:00                          # Duration of the job
#SBATCH --mem-per-cpu=64G                    # Memory per CPU
#SBATCH -qinferno                            # QOS name
#SBATCH -o featurizer_results/linspace_orders_sigmas.out  # Output file
#SBATCH --mail-type=BEGIN,END,FAIL           # Mail preferences
#SBATCH --mail-user=sgovil9@gatech.edu       # E-mail address for notifications

module load anaconda3
conda activate my_mdl_env
echo "linspace_orders_sigmas"
python get_gmp_features.py --linspace  --orders  --sigmas 
python gmp_feature_scaler.py --linspace  --orders  --sigmas 
