### This is a script to remove unnecessary files from image stack folders. Since
#### the file names often change, just copy the format and add in whatever other
#### files are necessary to remove. Also, check the list first to make sure you do
#### not want any of these files!!!!

#### The only files I am keeping are the stacks, tar.gz's, and Fmask outputs when I run fmask with new parameters. 
cd /projectnb/landsat/users/bullocke/Congo/images

#cd /projectnb/landsat/projects/CMS_Mexico/image

#find ./ -name 'L*MTLFmask*' -exec rm {} -v \;
find ./ -name 'L*MTLFmask' -exec rm {} -v \;
find ./ -name 'L*conf.tif' -exec rm {} -v \;
find ./ -name 'L*band11.tif' -exec rm {} -v \;
find ./ -name 'L*band10.tif' -exec rm {} -v \;
find ./ -name 'L*B9.TIF' -exec rm {} -v \;
find ./ -name 'L*BQA.TIF' -exec rm {} -v \;
find ./ -name 'L*B11.TIF' -exec rm {} -v \;
find ./ -name 'L*B10.TIF' -exec rm {} -v \;
find ./ -name 'L*B1.TIF' -exec rm {} -v \;
find ./ -name 'L*B2.TIF' -exec rm {} -v \;
find ./ -name 'L*B3.TIF' -exec rm {} -v \;
find ./ -name 'L*B4.TIF' -exec rm {} -v \;
find ./ -name 'L*B6_VCID*.TIF' -exec rm {} -v \;
find ./ -name 'L*B5.TIF' -exec rm {} -v \;
find ./ -name 'L*B6.TIF' -exec rm {} -v \;
find ./ -name 'L*B7.TIF' -exec rm {} -v \;
find ./ -name 'L*B8.TIF' -exec rm {} -v \;
find ./ -name 'L*GCP.TIF' -exec rm {} -v \;
find ./ -name 'L*fmask.tif' -exec rm {} -v \; ###you might want this if it is your only fmask file. 
find ./ -name 'L*fmask.tfw' -exec rm {} -v \;
find ./ -name 'L*cloud_qa.tif' -exec rm {} -v \;
find ./ -name 'L*cloud_qa.twf' -exec rm {} -v \;
find ./ -name 'L*opacity.tif' -exec rm {} -v \;
find ./ -name 'L*opacity.twf' -exec rm {} -v \;
find ./ -name 'L*_sr_*' -exec rm {} -v \;
find ./ -name 'L*toa_band6*' -exec rm {} -v \;
