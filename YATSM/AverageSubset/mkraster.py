#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""HTML Cleaner.

Usage:
  mkraster.py <filename>


"""


from docopt import docopt
import numpy as np
from osgeo import gdal
from osgeo import gdal_array
from osgeo import osr
import matplotlib.pylab as plt
import os
import sys
from gdalconst import *


if __name__ == '__main__':
    args = docopt(__doc__, version='0.1.0')
  

name = args['<filename>']
print name
#first make the mask work
os.system('gdal_calc.py -A %s --A_band 8 --outfile %s_test_mask --calc "A<2"' % (name, name))


#next make masked out values 0
os.system('gdal_calc.py -A %s --allBands=A -B %s_test_mask --outfile %s_test_mult --calc "A*B"' % (name, name, name))

os.system('gdal_calc.py -A %s_test_mult --allBands=A --outfile %s_test_32767 --calc="-32767*(A<1)"' % (name, name))

#now add them together
os.system('gdal_calc.py -A %s_test_32767 -B %s_test_mult --allBands=A --allBands=B --outfile %s_test_ndv --calc="A+B"' % (name, name, name))

#now set 0 to nodata
#os.system('gdal_translate -a_nodata 0 %s_test_mult %s_test_ndv' % (name, name))
ndv = -32767.0

src='%s_test_ndv' % (name)
src=str(src)
print src
src_ds = gdal.Open( src ) 
if src_ds is None:
    print 'Unable to open INPUT.tif'
    sys.exit(1)

list =[ 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]
for band in range( src_ds.RasterCount ):
    band += 1
    srcband = src_ds.GetRasterBand(band)
    srcband.SetNoDataValue(ndv)
    if srcband is None:
        continue

    stats = srcband.ComputeStatistics(0)
    if stats is None:
        continue

    list[band] = stats[2]
    print list[band]

list.remove(0.1)
array = np.array(list, ndmin=3)
   # print array.shape
print array
# My image array   

#now make the raster
dst_filename = '%s_final.tif' % (name)
#output to special GDAL "in memory" (/vsimem) path just for testing
#dst_filename = '/vsimem/test.tif'

#Raster size
nrows=1
ncols=1
nbands=8

#min & max random values of the output raster
zmin=0
zmax=12345

## See http://gdal.org/python/osgeo.gdal_array-module.html#codes
## for mapping between gdal and numpy data types
gdal_datatype = gdal.GDT_Float64
np_datatype = np.float64

driver = gdal.GetDriverByName( "GTiff" )
dst_ds = driver.Create( dst_filename, ncols, nrows, nbands, gdal_datatype )

## These are only required if you wish to georeference (http://en.wikipedia.org/wiki/Georeference)
## your output geotiff, you need to know what values to input, don't just use the ones below
#Coordinates of the lower left corner of the image
#in same units as spatial reference
xllcorner=553485.000  
yllcorner=-908715.000

#Cellsize in same units as spatial reference
cellsize=30

dst_ds.SetGeoTransform( [ xllcorner, cellsize, 0, yllcorner, 0, -cellsize ] )
srs = osr.SpatialReference()
srs.SetWellKnownGeogCS( "WGS84" )
dst_ds.SetProjection( srs.ExportToWkt() )


for band in range(nbands):
    dst_ds.GetRasterBand(band+1).WriteArray( array[:,:, band] )

# Once we're done, close properly the dataset
dst_ds = None   
