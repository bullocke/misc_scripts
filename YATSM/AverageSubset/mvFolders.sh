cd /projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1946_2046/images

for img in $(find ./ -maxdepth 1 -type f -name 'L*'); do

        id=$(basename $img)
        filename=${img:0:18}
        echo $filename
       # mkdir $filename
        mv $img $filename

done
