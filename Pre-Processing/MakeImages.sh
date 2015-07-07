#!/bin/bash
#$ -V
#$ -l h_rt=48:00:00
#$ -N previews
#$ -j y

module load gdal/1.10.0
module load batch_landsat/v4

cd /projectnb/landsat/projects/NRT_MODIS/227063/images
for stack in $(find ./ -maxdepth 2 -name 'L*stack'); do
    id=$(basename $stack)
    echo "Making preview image for $id"
#    gen_preview.py -b "5 4 3" --mask 7 --maskval -9999 --srcwin '0 1437 400 400' --manual "0 8000" $stack ${id}_previewsubset.jpeg
    gen_preview.py -b "5 4 3" --manual "0 8000" $stack ${id}_preview.jpeg
    
done

echo "Done!"
