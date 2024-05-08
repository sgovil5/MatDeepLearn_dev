#!/bin/bash

input="gmp_pretrain_params.txt"

dos2unix $input
if [[ -n $(tail -n 1 "$input") ]]; then
    echo >> "gmp_pretrain_params.txt"
fi

if [ ! -f "$input" ]; then
    echo "File not found: $input"
    exit 1
fi

while IFS= read -r line
do
    read -r linspace orders sigmas <<< "$line"
    # Check if linspace, orders, and sigmas are valid
    if [[ -z "$linspace" || -z "$orders" || -z "$sigmas" ]]; then
        echo "Invalid input: $line"
        continue
    fi

    echo $linspace $orders $sigmas

    cp configs/GMP_pretraining_backup.yml configs/GMP_pretraining.yml
    sed -e "s/\${linspace}/$linspace/g" -e "s/\${orders}/$orders/g" -e "s/\${sigmas}/$sigmas/g" -e "s/\${scale}//g" pretrain_template.sh > normal_pretrain.sh
    bash normal_pretrain.sh
    cp configs/GMP_pretraining_backup.yml configs/GMP_pretraining.yml

    sed -e "s/\${linspace}/$linspace/g" -e "s/\${orders}/$orders/g" -e "s/\${sigmas}/$sigmas/g" -e "s/\${scale}/_robust/g" pretrain_template.sh > robust_pretrain.sh
    bash robust_pretrain.sh
    cp configs/GMP_pretraining_backup.yml configs/GMP_pretraining.yml

    sed -e "s/\${linspace}/$linspace/g" -e "s/\${orders}/$orders/g" -e "s/\${sigmas}/$sigmas/g" -e "s/\${scale}/_minmax/g" pretrain_template.sh > minmax_pretrain.sh
    bash minmax_pretrain.sh
    cp configs/GMP_pretraining_backup.yml configs/GMP_pretraining.yml
done < "$input"
