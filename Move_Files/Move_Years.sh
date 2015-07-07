#### This script removes images from a stack before a certain year. In this
#### example it is moving all images before 2005 to a folder named 'Older'. If you
#### want to remove all images after a certain year change '-lt' to '-gt'. If you
#### want to remove images between certain years do something like this:
#### if [ $year -gt 1990 -a $year -lt 2005 ]. This would remove files between 1990
#### and 2005. 


cd /projectnb/landsat/projects/CMS_Mexico/images/034039/images

mkdir Older

for img in $(find . -name 'L*' -type d); do

	id=$(basename $img)
	echo "$id"
	year=${id:9:4}
	if [ $year -lt 2005 ]
	then
		mv $img Older
		echo "moving $img"
	fi
	
	
done

echo "done"
