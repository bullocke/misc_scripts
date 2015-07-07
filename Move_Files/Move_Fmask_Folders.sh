cd /projectnb/landsat/projects/CMS_Mexico/images/022047/images

mkdir ../doneFmask
mkdir ../needFmask

for img in $(find ./ -name 'L*MTLFmask'); do

base=$(basename $img)
fodler=${base:0:16}
echo $fodler

mv ${fodler}* ../doneFmask

done


for tar in $(find ./ -name 'L*tar.gz'); do 

mv $tar ../needFmask

done
