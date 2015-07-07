#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N YATSM_map
#$ -j y


#cd /projectnb/landsat/users/bullocke/CCDC/YATSM/yatsm/scripts
#cd /projectnb/landsat/users/bullocke/Cirrus_Mask/Synthetic
cd /projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1947_2046/

#module load batch_landsat/v4



/projectnb/landsat/users/bullocke/yatsm_old/scripts/yatsm_map.py --after --root "/projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1947_2046/images/" \
--date "%Y-%j" -i "example_img" --robust -r YATSM2 -f ENVI -v \
predict 2004-105 SR_TEST

