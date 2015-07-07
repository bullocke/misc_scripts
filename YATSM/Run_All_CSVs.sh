#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N IDS
#$ -j y
for i
do
dirr=$(echo $i)
done


cd /projectnb/landsat/users/bullocke/testing/yatsm_csv2/scripts

module load batch_landsat/v4
outpath=/projectnb/landsat/users/bullocke/IDS/Testing_CSVs/Training_npz/18/${dirr}
accpath=/projectnb/landsat/users/bullocke/IDS/Testing_CSVs/18

#for img in $(find /projectnb/landsat/users/bullocke/IDS/Testing_CSVs/Acc_CSVs -name '*csv'); do
for img in $(find /projectnb/landsat/users/bullocke/IDS/Testing_CSVs/Training/Samples_ByPR/Together/${dirr}/ -name '*csv'); do
python run_yatsm.py --lassocv --consecutive=8  --test_indices "2 4 5" \
--threshold=4 --min_rmse=100 --min_obs=14 --plot_index=5 --plot_ylim "0 5000" --screening \
LOWESS --freq="1, 2" --image_pattern='L*subset' --outputpath $outpath \
$img 1 1
echo $img 
done

#RLM --freq="1" --image_pattern='L*subset' --outputpath $accpath \
