cd /projectnb/landsat/datasets/MODIS/h12v09/stacks_buf3/change_maps
#cd /usr3/graduate/bullocke/ccdc/ceholden/yatsm_test/scripts

module load batch_landsat/v4

for img in {2000..2014}; do

qsub -V -j y -b y $(which python) /projectnb/landsat/users/bullocke/testing/YATSM/yatsm/scripts/yatsm_changemap.py --root "/projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1948_2047/images" -r YATSM -i example_img -f ENVI -v since $img-04-15 $img-04-16 DateSince_1948_2047_${img}_4_15

done
