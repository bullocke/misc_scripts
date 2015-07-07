#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N YATSM_map
#$ -j y

cd /projectnb/landsat/users/bullocke/yatsm_newest/yatsm/scripts
cd /projectnb/landsat/datasets/MODIS/h12v09/stacks_buf3
#cd /projectnb/landsat/users/bullocke/testing/YATSM/yatsm/scripts


module load batch_landsat/v4

/projectnb/landsat/users/bullocke/yatsm_newest/yatsm/scripts/yatsm_changemap.py --root "./" -r YATSM -i example_img.gtif -v first 2003-01-01 2013-12-31 h12v09_change_first_from_2003001.gtif


#./yatsm_changemap.py --root "/projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1946_2045/images/" -r YATSM_12 -i example_img -v num 1980-01-01 2014-12-31 1946_2045_Num_Change_12.gtif
