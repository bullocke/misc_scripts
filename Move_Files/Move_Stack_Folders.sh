cd /projectnb/landsat/projects/CMS_Mexico/images/020049/images

mkdir ../doneStack

for img in $(find ./ -name 'L*stack'); do

base=$(basename $img)
fodler=${base:0:16}
echo $fodler

mv ${fodler}* ../doneStack

done

