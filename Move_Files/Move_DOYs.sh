### This script removes only files from a stack for certain periods of the year. 
### This is useful if you want to remove all images from the rainy part of the
### year, or all winter images due to snow. In this example it is moving all
### images from day 100 to 150 to a folder named 'RainSeason'.


cd /projectnb/landsat/projects/CMS_Mexico/images/020048/images

mkdir RainSeason

for img in $(find . -name 'L*' -type d); do

	id=$(basename $img)
	echo "$id"
	doy=${id:13:3}
	if [ $doy -gt 100 -a $doy -lt 150 ]
	then
		mv $img RainSeason
		echo "moving $img"
	fi
	
	
done

echo "done"
