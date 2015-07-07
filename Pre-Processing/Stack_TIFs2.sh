#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N stack
#$ -j y


####This script is for stacking TIF-format surface reflectance files. This is just using Chris Holden's landsat_stack.py utility. 

module load gdal/1.10.0
module load batch_landsat/v4

cd /projectnb/landsat/projects/CMS_Mexico/images/021050/images

#cd /usr3/graduate/bullocke/ccdc/test/P018-R045


landsat_stack.py -v -p -n "-9999; -9999; -9999; -9999; -9999; -9999; -9999; 255" --files "L*sr_band1.tif; L*sr_band2.tif; L*sr_band3.tif; L*sr_band4.tif; L*sr_band5.tif; L*sr_band7.tif; L*band6.tif; L*MTLFmask" --utm 15 -o "*_stack" --format "ENVI" --co "INTERLEAVE=BIP" --max_extent ./
