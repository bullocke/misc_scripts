cd /projectnb/landsat/users/bullocke/testing/CCDC_Visualization


for img in $(find ./ -name '*FinThresh.tif'); do

gdal_translate -a_nodata -9999 -srcwin 3750 4000 500 500 $img subsets/${img}_subset

done
