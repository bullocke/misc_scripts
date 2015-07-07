#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N stack_L8
#$ -j y


####This is for stacking new LC8 images to an existing image stack

module load gdal/1.10.0
module load batch_landsat/v4

cd /projectnb/landsat/users/bullocke/Vietnam/Conference/P124-R052

landsat_stack.py -v -p -n "-9999; -9999; -9999; -9999; -9999; -9999; -9999; 255" \
 --files "L*sr_band2.tif; L*sr_band3.tif; L*sr_band4.tif; L*sr_band5.tif; L*sr_band6.tif; L*sr_band7.tif; L*band10.tif; L*cfmask.tif" -o "*_stack" --format "ENVI" --co "INTERLEAVE=BIP" --image=/projectnb/landsat/users/jss5102/Vietnam/124_52/LE71240522010251SGS00/LE71240522010251SGS00_stack ./
