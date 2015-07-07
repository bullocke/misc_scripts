cd /projectnb/landsat/users/bullocke/testing/WebMap/p003r067/PredictedImages

for img in $(find ./ -name 'SR*' ! -name '*aux.xml' ! -name '*hdr');

gdal_translate 
