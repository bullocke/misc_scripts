#!/bin/bash
#$ -V
#$ -pe omp 3
#$ -l h_rt=120:00:00
#$ -N Fmask
#$ -j y

module load gdal/1.10.0
module load batch_landsat

cd /projectnb/landsat/projects/CMS_Mexico/images/020045/newfmask

# Define MATLAB single threaded "batch" runtime
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

# Define MATLAB command to run - let's use 12.5 as cloud probabilty and dilate clouds and shadow by 5 and 4
CMD="addpath('/usr3/graduate/zhuzhe/Algorithms/Fmask');clr_pct=autoFmask(5,4,3,12.5);fprintf('CLEAR=%f\n',clr_pct);exit;"

# Loop over all images running Fmask
here=$(pwd)

for img in $(find ./ -name 'L*' -type d); do
    cd $img
    
    # Let's not just run Fmask, but also capture clear percentage
    clear=$($ML $CMD | grep "CLEAR=")
    
    # Find Fmask
    fmask=$(find ./ -name '*Fmask')
    # Add clear percent to metadata
    gdal_edit.py -mo "$clear" $fmask
    
    cd $here
done

echo "Done!"
