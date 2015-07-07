#### This is a script for extracting a single band from a stack. 
#### In this example it is looking for all files in the /delta folder with the
#### name 'L*vi*tif' and taking out band 8 (which is NDVI). If you just want to do
#### this for one file do: gdal_translate -b 1 filename outputname. 


cd /projectnb/landsat/projects/Vietnam/p125r053/images/delta

module load gdal

for img in $(find . -name 'L*vi*tif'); do
	echo "Extracting NDVI of $img"

	id=$(basename $img)
	output=${id}_ndvi

	gdal_translate -b 8 $img $output

done

echo "Done" 
