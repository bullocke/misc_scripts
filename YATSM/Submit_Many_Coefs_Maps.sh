cd /projectnb/landsat/projects/CMS_Mexico/Progress/Predicted_Images/Random/working/020047/
#$ -l eth_speed=10
#cd /projectnb/landsat/users/bullocke/yatsm/scripts
#cd /usr3/graduate/bullocke/ccdc/ceholden/yatsm_test/scripts

module load batch_landsat/v4

for img in {2000..2000}; do

qsub -V -j y -b y $(which python) /projectnb/landsat/users/bullocke/yatsm_old/scripts/yatsm_map.py --root "/projectnb/landsat/projects/CMS_Mexico/images/020047/images" -r YATSM --robust --ndv -9999 -i example_img --coef "intercept" -f ENVI --before -v coef $img-04-15 Intercept_020047_${img}_4_15

done
