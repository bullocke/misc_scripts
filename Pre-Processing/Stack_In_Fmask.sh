#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N Fmask_stack
#$ -j y
#$ -l eth_speed=10

####This script is for stacking TIF-format surface reflectance files. This is just using Chris Holden's landsat_stack.py utility. 

module load gdal/1.10.0
module load batch_landsat/v4

cd /projectnb/landsat/projects/CMS_Mexico/images/019046/7.5/images
#cd /projectnb/landsat/users/bullocke/ACRE/P003-R067

landsat_stack.py -v --files "L*stack; L*MTLFmask" -b '1 2 3 4 5 6 7; 1' -n '-9999 -9999 -9999 -9999 -9999 -9999 -9999; 255' --utm 16 -o "*_stack3" --format 'ENVI' --co 'INTERLEAVE=BIP' --max_extent ./
