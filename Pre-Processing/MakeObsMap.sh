#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N Obs_Map
#$ -j y


module load gdal/1.10.0
module load batch_landsat/v4

cd /projectnb/landsat/users/bullocke/nobchart

./stack_nobs.py /projectnb/landsat/projects/CMS_Mexico/images/034039/images/ 034039_obs.gtif 2 3 4
