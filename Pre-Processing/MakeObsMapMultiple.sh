#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N Obs_Map
#$ -j y


module load gdal/1.10.0
module load batch_landsat/v4

cd /projectnb/landsat/users/bullocke/nobchart

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/020046/images/ 020046_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/020045/images/ 02045_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/019048/images/ 019048_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/019047/images/ 019047_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/019046/images/ 019046_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/019045/images/ 019045_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/018047/images/ 018047_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/018046/images/ 018046_obs.gtif 2 3 4

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/018045/images/ 018045_obs.gtif 2 3 4
