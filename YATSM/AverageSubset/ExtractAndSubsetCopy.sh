#!/bin/bash
#$ -V
#$ -l h_rt=24:00:00
#$ -N Subsets2
#$ -j y

module load batch_landsat/v4

#what is the path of the shapefile?

shapefile='/projectnb/landsat/users/bullocke/Segmentation/Shapefiles/6_3.shp'
directory='/projectnb/landsat/projects/USGS_SITES/p023r037/images'
example='/projectnb/landsat/projects/USGS_SITES/p023r037/images/example_img'
output1='/projectnb/landsat/users/bullocke/Segmentation/AveragePixels/6_3/'


function gdal_extent() {
    if [ -z "$1" ]; then 
        echo "Missing arguments. Syntax:"
        echo "  gdal_extent <input_raster>"
        return
    fi
    EXTENT=$(gdalinfo $1 |\
        grep "Upper Left\|Lower Right" |\
        sed "s/Upper Left  //g;s/Lower Right //g;s/).*//g" |\
        tr "\n" " " |\
        sed 's/ *$//g' |\
        tr -d "[(,]")
    echo -n "$EXTENT"
}

function ogr_extent() {
    if [ -z "$1" ]; then 
        echo "Missing arguments. Syntax:"
        echo "  ogr_extent <input_vector>"
        return
    fi
    EXTENT=$(ogrinfo -al -so $1 |\
        grep Extent |\
        sed 's/Extent: //g' |\
        sed 's/(//g' |\
        sed 's/)//g' |\
        sed 's/ - /, /g')
    EXTENT=`echo $EXTENT | awk -F ',' '{print $1 " " $4 " " $3 " " $2}'`
    echo -n "$EXTENT"
}

img_ext=$(gdal_extent $example)
shp_ext=$(ogr_extent $shapefile)

pix=$(gdalinfo $example \
    | grep "Pixel Size" | sed "s/Pixel.*(//g;s/,/ /g;s/)//g")
pix_sz="$pix $pix"
echo 'Pix size is:' $pix_sz

echo "Extent of stacked images and extent of shapefile:"
echo $img_ext
echo $shp_ext

new_ext=""

for i in 1 2 3 4; do
    # Get the ith coordinate from sequence
    r=$(echo $img_ext | awk -v i=$i '{ print $i }')
    v=$(echo $shp_ext | awk -v i=$i '{ print $i }')
    pix=$(echo $pix_sz | awk -v i=$i '{ print $i }')
    # Quick snippit of Python
    ext=$(python -c "\\
        offset=int(($r - $v) / $pix); \
        print $r - offset * $pix\
        ")
    echo $ext
    new_ext="$new_ext $ext"
done

echo "Calculated new extent:"
echo $new_ext

# Now, unfortunately, gdalwarp wants us to specify xmin ymin xmax ymax
# In this case, this corresponds to the upper left X, lower right Y, lower right X, and upper left Y
warp_ext=$(echo $new_ext | awk '{ print $1 " " $4 " " $3 " " $2 }')
echo "gdalwarp extent:"
echo $warp_ext

# Perform the clip:

for stack in $(find $directory -maxdepth 2 -name '*stack'); do
    echo "Stack is $stack"
   
    base=$(basename $stack)
    echo $base
    output=${output1}${base}_subset
    echo $output
    
    gdalwarp -of ENVI -co "INTERLEAVE=BIP" -te $warp_ext -tr 30 30 \
        -cutline $shapefile \
        -dstnodata -9999 -wm 2000 \
        $stack $output

done

for img in $(find $output1 -name 'L*subset'); do
	echo "eric the file is $img"
	python mkraster.py $img;

done

cd $output1

for img in $(find ./ -maxdepth 1 -name 'L*final.tif'); do

	id=$(basename $img)
        filename=${img:0:23}
	echo $filename
	mkdir $filename
	mv $img $filename

done
