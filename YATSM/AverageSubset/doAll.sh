#!/bin/bash
#$ -V
#$ -l h_rt=24:00:00
#$ -N Subsets
#$ -j y



for img in $(find ./ -name 'L*subset'); do

python mkraster.py $img;

done
