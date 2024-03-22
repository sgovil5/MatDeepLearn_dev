#!/bin/bash

input="gmp_params.txt"

dos2unix $input
echo >> gmp_params.txt

if [ ! -f "$input" ]; then
    echo "File not found: $input"
    exit 1
fi

while IFS= read -r line
do
    read -r linspace orders sigmas <<< "$line"
    echo $linspace $orders $sigmas
    sed -e "s/\${linspace}/$linspace/g" -e "s/\${orders}/$orders/g" -e "s/\${sigmas}/$sigmas/g" featurizer_template.sh > temp_featurizer.sh
    sbatch temp_featurizer.sh
done < "$input"