#!/bin/bash

#SBATCH -J linspace${linspace}_orders${orders}_sigmas${sigmas}   # Job name
#SBATCH -A gts-vfung3                        # Charge account
#SBATCH -t24:00:00                          # Duration of the job
#SBATCH --mem-per-cpu=64G                    # Memory per CPU
#SBATCH -qinferno                            # QOS name
#SBATCH -o featurizer_results/linspace${linspace}_orders${orders}_sigmas${sigmas}.out  # Output file
#SBATCH --mail-type=BEGIN,END,FAIL           # Mail preferences
#SBATCH --mail-user=sgovil9@gatech.edu       # E-mail address for notifications

module load anaconda3
conda activate my_mdl_env
echo "linspace${linspace}_orders${orders}_sigmas${sigmas}"
python get_gmp_features.py --linspace ${linspace} --orders ${orders} --sigmas ${sigmas}
python gmp_feature_scaler.py --linspace ${linspace} --orders ${orders} --sigmas ${sigmas}
