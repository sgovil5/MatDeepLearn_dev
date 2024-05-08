module load python
conda activate matdeeplearn

data_paths=(
    "data/GVRH/data_log_gvrh.json"
    "data/KVRH/data_log_kvrh.json"
)

pt_paths=(
    "data/GVRH/"
    "data/KVRH/"
)

seeds=(
    111
    222
    333
    444
    555
)

# dry run
for i in {0..1}; do
    data_path=${data_paths[i]}
    pt_path=${pt_paths[i]}

    for seed in "${seeds[@]}"; do
        echo "data_path: $data_path"
        echo "pt_path: $pt_path"
        echo "seed: $seed"

        python scripts/main.py \
            --run_mode=finetune \
            --config_path=configs/gmp_finetune20.yml \
            --src_dir=$data_path \
            --pt_path=$pt_path \
            --seed=$seed \
            --batch_size=32 \
            --num_epochs=200 \
            --processed=False
    done
done
