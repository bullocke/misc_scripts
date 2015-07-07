cd /projectnb/landsat/projects/CMS_Mexico/Progress/Predicted_Images/RMSEs
#cd /projectnb/landsat/users/bullocke/yatsm/scripts
#cd /usr3/graduate/bullocke/ccdc/ceholden/yatsm_test/scripts

module load batch_landsat/v4

for img in {1..12}; do

qsub -V -j y -b y $(which python) /projectnb/landsat/users/bullocke/yatsm_old/scripts/yatsm_map.py --root "/projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1947_2046/images" -r YATSM --robust -i example_img -f ENVI --coef "rmse" -v --before coef 2008-${img}-15 SR_1947_2046_2008_${img}_15

done
