#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N IDS
#$ -j y

cd /projectnb/landsat/users/bullocke/testing/yatsm_csv2/scripts

module load batch_landsat/v4


for img in $(find /projectnb/landsat/users/bullocke/IDS/Testing_CSVs/Acc_CSVs -name '*csv'); do


echo $img
python run_yatsm.py --lassocv --consecutive=6  --test_indices "2 3 4 5" \
--threshold=3 --min_rmse=100 --min_obs=8 --plot_index=5 --plot_ylim "0 5000" --screening \
LOWESS --freq="1" --image_pattern='L*subset' --outputpath='/projectnb/landsat/users/bullocke/IDS/Testing_CSVs/Training_npz/7/1' \
$img 1 1

done
