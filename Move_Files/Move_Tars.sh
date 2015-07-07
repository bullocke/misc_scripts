#cd /projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1946_2045/22.5
cd /projectnb/landsat/projects/CMS_Mexico/images/020045/22.5/

for img in $(find ./ -name 'L*tar.gz'); do
echo $img
name=$(basename $img)
folder=${name:0:16}
mv $img /projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1946_2045/22.5/${folder}


done
