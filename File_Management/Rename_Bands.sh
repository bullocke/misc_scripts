#### When downlading images from ESPA in TIF format and using the landsat_IndexStack
#### tool to IndexStack the TIF files, I have noticed that sometimes the band names do not
#### carry over to the IndexStack (so instead of saying Fmask for band 8 it will just say
#### band 8). Usually this does not matter, but if you are doing a IndexStack that has
#### spectral indices in it, or a different variation of bands, this might make
#### things confusing. This script is an ugly way of fixing that. Basically it opens
#### the header files and manually looks for the bandname and changes it. Each line
#### in the script is changing a different band name. The first one is changing Band
#### 1 to Band_1 Reflectance, the second is changing Band 2 to Band_2 Reflectance,
#### and so on. It is essential that whatever you change the bandname to has an
#### underscore in it, or else you might get a loop where it will change one band
#### name, and then change it again the next time through (such as with band 6 and
#### 7). The underscore prevents it from finding it the second time. 


# I STRONGLY suggest trying this on one image first to make sure it works the way
# you want it to!!!. 

# This example is changing all the *IndexStack.hdr files in a folder, if you want
# other files changed then change it accordingly. 


#cd /projectnb/landsat/users/bullocke/testing/Indices
cd /projectnb/landsat/projects/Colombia/images/007059/images


for img in $(find ./ -maxdepth 1 -name 'L*' -type d); do
    echo "Changing bandnames of $img"
    
	perl -p -i.bak -e 's/Band 1,/Band_1 Reflectance,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 2,/Band_2 Reflectance,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 3,/Band_3 Reflectance,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 4,/Band_4 Reflectance,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 5,/Band_5 Reflectance,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 6,/Band_7 Reflectance,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 7,/Band_6 Temperature,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 8,/Fmask,/g' $img/*IndexStack.hdr
        perl -p -i.bak -e 's/Band 9,/NDVI*1000,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 10,/Simple Ratio*1000,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 11,/NBR*1000,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 12,/EVI*1000,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 13,/EVI2*1000,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 14,/Brightness,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 15,/Greenness,/g' $img/*IndexStack.hdr
	perl -p -i.bak -e 's/Band 16}/Wetness}/g' $img/*IndexStack.hdr	
done
echo "Done"
