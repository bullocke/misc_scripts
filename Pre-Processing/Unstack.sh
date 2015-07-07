cd /projectnb/landsat/projects/CMS_Mexico/images/Combined_Overlap/1946_2045/22.5/


for img in $(find ./ -name 'L*019046*subset'); do 

gdal_translate -b 1 $img ${img}_sr_band1.tif
gdal_translate -b 2 $img ${img}_sr_band2.tif
gdal_translate -b 3 $img ${img}_sr_band3.tif
gdal_translate -b 4 $img ${img}_sr_band4.tif
gdal_translate -b 5 $img ${img}_sr_band5.tif
gdal_translate -b 6 $img ${img}_sr_band5.tif
gdal_translate -b 7 $img ${img}_toa_band6.tif



done
