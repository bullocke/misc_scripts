
#directory where the files to be mosaicked live:
direc=/projectnb/landsat/projects/CMS_Mexico/images/020048/images/4910line/test

#files to be mosaicked (seperated by space)
files='LT50200481986184XXX03_stack_4910line LT50200481986200XXX03_stack_4910line'

#output name
output=mosaic

cd $direc 

module load gdal/1.10.0


gdal_merge.py -o $output -of ENVI -co "INTERLEAVE=BIP" $files
