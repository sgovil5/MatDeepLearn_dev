module load python
conda activate matdeeplearn

data_paths=(
    "data/JDFT/data_exfoliation.json"
    "data/Phonons/data_phonons.json"
    "data/GVRH/data_log_gvrh.json"
    "data/KVRH/data_log_kvrh.json"
    "data/Perovskites/data_perovskites.json"
)

pt_paths=(
    "data/JDFT/"
    "data/Phonons/"
    "data/GVRH/"
    "data/KVRH/"
    "data/Perovskites/"
)

seeds=(
    111
    222
    333
    444
    555
)

# dry run
for i in {0..4}; do
    data_path=${data_paths[i]}
    pt_path=${pt_paths[i]}

    for seed in "${seeds[@]}"; do
        echo "data_path: $data_path"
        echo "pt_path: $pt_path"
        echo "seed: $seed"

        python scripts/main.py \
            --run_mode=train\
            --config_path=configs/gmp_finetune.yml \
            --src_dir=$data_path \
            --pt_path=$pt_path \
            --seed=$seed \
            --batch_size=32 \
            --num_epochs=200 \
            --processed=False
    done
done
