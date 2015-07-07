cd /projectnb/landsat/datasets/MODIS/h12v09/stacks_buf3
#cd /usr3/graduate/bullocke/ccdc/ceholden/yatsm_test/scripts

module load batch_landsat/v4

#for img in {2000..2014}; do

#qsub -V -j y -b y $(which python) /projectnb/landsat/users/bullocke/yatsm_newest/yatsm/scripts/yatsm_changemap.py --root "/projectnb/landsat/datasets/MODIS/h12v09/stacks_buf3/" -r YATSM -i example_img.gtif -f GTiff -v num $img-01-01 $img-12-31 Changes_${img}

#done

qsub -V -j y -b y $(which python) /projectnb/landsat/users/bullocke/yatsm_newest/yatsm/scripts/yatsm_changemap.py --root "/projectnb/landsat/datasets/MODIS/h12v09/stacks_buf3/" -r YATSM -i example_img.gtif -f GTiff -v first 2000-01-01 2014-12-31 Changes_First
