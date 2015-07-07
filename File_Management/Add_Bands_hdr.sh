#### This script adds bandnames to the header file of an image. This is useful
#### for synthetic images or any image in which the header only has the basic
#### information. This example searches for all files in a folder with the name
####'S*hdr', the ! means not...so this folder has many images of different pixel
#### resolutions, and it is only searching for the original files. Change the band
#### names as desired, and to add a new line just add \nBandName whereever you want
#### it to go. 

###I STRONGLY suggest testing this one one image before doing it to to a folder
###of images!!!!!

cd /projectnb/landsat/users/bullocke/testing/Indices
#cd /usr3/graduate/bullocke/ccdc/test

#for img in $(find . -name 'S*hdr' ! -name 'S*120.hdr' ! -name 'S*210.hdr' ! -name 'S*300.hdr' ! -name 'S*390.hdr' ! -name 'S*480.hdr'); do
    echo "Changing bandnames of $img"
for img in $(find ./ -name '*hdr'); do
    echo "Changing bandnames of $img"



perl -p -i.bak -e 's/Meters}/Meters}\nband names = {\nBand_1 Reflectance,\nBand_2 Reflectance,\nBand_3 Reflectance,\nBand_4 Reflectance,\nBand_5 Reflectance,\nBand_7 Reflectance,\nBand_6 Temperature,\nFmask,\nNDVI*1000,\nSimple Ratio*1000,\nNBR*1000,\nEVI*1000,\nEVI2*1000,\nBrightness,\nGreenness,\nWetness}/g' $img

done
echo "done" 
