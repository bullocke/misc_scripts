cd /projectnb/landsat/projects/CMS_Mexico/images/021048/needFmask

for img in $(find ./ -name 'L*tar.gz'); do

name=$(basename $img)
folder=${name:0:16}
mv $img ../images/${folder}*


done
