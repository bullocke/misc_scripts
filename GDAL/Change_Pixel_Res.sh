#!/bin/bash
#$ -V
#$ -l h_rt=24:00:00
#$ -N Resample
#$ -j y


####This is a basic script to rescale the pixel resolution of an image... 


file=2*SR #what is the file format for the images you want to rescale?
p_size=480 #What pixel size (m) do you want to rescale the resolution to?
method=average #Resampling method. Options are: near, bilinear, cubic, cubicspline, lanczos, mode
end=_480 #Ending of the output file
direc=/projectnb/landsat/projects/CMS_Mexico/Progress/Predicted_Images/Products/SR

module load gdal/1.10.0

#cd /projectnb/landsat/projects/CMS_Mexico/images/034039/images/TSFitMap/PredictAll ##change this to your working folder
cd $direc

for img in $(find ./ -name '2*SR'); do 
	echo "Resampling for $img"

	id=$(basename $img)

	gdalwarp -tr $p_size $p_size -r $method $img tempImg

	gdal_translate -of ENVI -co "INTERLEAVE=BIP" tempImg ${id}${end}

	rm tempI*


done	

echo "done"
