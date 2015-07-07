#!/bin/bash
#$ -V
#$ -l eth_speed=10
#$ -l h_rt=48:00:00
#$ -N indice_stack
#$ -j y
for i
do
dirr=$(echo $i)
done

#for img in $(find $dirr -name 'L*stack'); do
echo $img

fullfile=$img
path=$(dirname $img)
name=${img##*/}

module load batch_landsat/v4
#NDVI
gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXNDVI --calc "((D.astype(float)-C)/(D.astype(float)+C))*1000" --NoDataValue=-9999

#Simple Ratio
gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXSR --calc "((D.astype(float)/C))*1000" --NoDataValue=-9999

#NBR
gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXNBR --calc "((D.astype(float)-F)/(D.astype(float)+F))*1000" --NoDataValue=-9999

#EVI
gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXEVI --calc "(2.5*((D.astype(float)-C)/(D.astype(float)+(6*C.astype(float))-(7.5*A.astype(float))+1)))*1000" --NoDataValue=-9999

#EVI2
gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXEVI2 --calc "(2.5*((D.astype(float)-C)/(D.astype(float)+(2.4*C.astype(float))+1))*1000" --NoDataValue=-9999

#Brightness
gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXBrightness --calc "((A.astype(float)*.2043)+(B.astype(float)*.4158)+(C.astype(float)*.5524)+(D.astype(float)*.5741)+(E.astype(float)*.3124)+(F.astype(float)*.2303))" --NoDataValue=-9999

#Greenness
#gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXGreenness --calc "((A.astype(float)*-.1603)+(B.astype(float)*-.2819)+(C.astype(float)*-.4934)+(D.astype(float)*.7940)+(E.astype(float)*-.0002)+(F.astype(float)*-.1446))" --NoDataValue=-9999

#Wetness
#gdal_calc.py -A $img --A_band 1 -B $img --B_band 2 -C $img --C_band 3 -D $img --D_band 4 -E $img --E_band 5 -F $img --F_band 6 -G $img --G_band 7 -H $img --H_band 8 --outfile ${path}/${name}_TempXWetness --calc "((A.astype(float)*.0315)+(B.astype(float)*.2021)+(C.astype(float)*.3102)+(D.astype(float)*.1594)+(E.astype(float)*-.6806)+(F.astype(float)*-.6109))" --NoDataValue=-9999

#done

landsat_stack.py --files "*stack; *TempXNDVI; *TempXSR; *TempXNBR; *TempXEVI; *TempXEVI2; *TempXBrightness; *TempXGreenness; *TempXWetness" -b "1 2 3 4 5 6 7 8; 1; 1; 1; 1; 1; 1; 1; 1" -o "*IndexStack" -n "-9999 -9999 -9999 -9999 -9999 -9999 -9999 255; -9999; -9999; -9999; -9999; -9999; -9999; -9999; -9999" --format "ENVI" --co "INTERLEAVE=BIP" --max_extent $dirr

#for img in $(find $dirr -name 'TempXNDVI'); do rm $img; done
#for img in $(find $dirr -name 'TempXSR'); do rm $img; done
#for img in $(find $dirr -name 'TempXNBR'); do rm $img; done
#for img in $(find $dirr -name 'TempXEVI'); do rm $img; done
#for img in $(find $dirr -name 'TempXEVI2'); do rm $img; done
#for img in $(find $dirr -name 'TempXBrightness'); do rm $img; done
#for img in $(find $dirr -name 'TempXGreenness'); do rm $img; done
#for img in $(find $dirr -name 'TempXWetness'); do rm $img; done
