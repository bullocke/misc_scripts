cd /projectnb/landsat/projects/CMS_Mexico/Progress/Predicted_Images/Random/working/020047
#cd /projectnb/landsat/users/bullocke/yatsm/scripts
#cd /usr3/graduate/bullocke/ccdc/ceholden/yatsm_test/scripts

module load batch_landsat/v4

for img in {2000..2014}; do

qsub -V -j y -b y $(which python) /projectnb/landsat/users/bullocke/yatsm_old/scripts/yatsm_map.py --root "/projectnb/landsat/projects/CMS_Mexico/images/020047/images" -r YATSM --ndv -9999 --robust -i example_img -f ENVI -v --before predict $img-04-15 SR_020047_${img}_4_15

done
