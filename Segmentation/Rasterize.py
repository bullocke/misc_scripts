#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""Rasterize a segmentation image vector
Usage:
  Rasterize.py <filename> <output>
"""

from docopt import docopt
import gdal
import numpy as np
from osgeo import ogr


if __name__ == '__main__':
    args = docopt(__doc__, version='0.1.0')


name = args['<filename>']
output = args['<output>']

pixel_size=30
orig_data_source = ogr.Open(name)
BandNum='Band1'
# Make a copy of the layer's data source because we'll need to
# modify its attributes table
source_ds = ogr.GetDriverByName("Memory").CopyDataSource(
        orig_data_source, "")
source_layer = source_ds.GetLayer(0)
source_srs = source_layer.GetSpatialRef()

#Iterate over features
features=['meanB0', 'meanB1', 'meanB2', 'meanB3', 'meanB4', 'meanB5', 'meanB6', 'varB0', 'varB1', 'varB2', 'varB3', 'varB4', 'varB5', 'varB6']
x_min, x_max, y_min, y_max = source_layer.GetExtent()
# Create the destination data source
x_res = int((x_max - x_min) / pixel_size)
y_res = int((y_max - y_min) / pixel_size)
numBands=len(features)
# Write MultiBand Raster
final_ds = gdal.GetDriverByName('GTiff').Create(output, x_res, y_res, numBands, gdal.GDT_Int32)
final_ds.SetGeoTransform((x_min, pixel_size, 0, y_max, 0, -pixel_size))
final_ds.SetProjection(source_srs.ExportToWkt())
bandNum = 0
#Now do the loop
for f in features:
    bandNum += 1
    target_ds = gdal.GetDriverByName('MEM').Create('temp', x_res,
        y_res, 1, gdal.GDT_Int32)
    target_ds.SetGeoTransform((
        x_min, pixel_size, 0,
        y_max, 0, -pixel_size,
        ))
    band = target_ds.GetRasterBand(1)
    band.SetNoDataValue(-9999)
    if source_srs:
    # Make the target raster have the same projection as the source
        target_ds.SetProjection(source_srs.ExportToWkt())
    else:
    # Source has no projection (needs GDAL >= 1.7.0 to work)
        target_ds.SetProjection('LOCAL_CS["arbitrary"]')
    # Rasterize
    gdal.RasterizeLayer(target_ds, [1], source_layer,
            options = ["ATTRIBUTE={}".format(f)])
    # Turn into vector
    array = band.ReadAsArray()
    #Write into final file
    final_ds.GetRasterBand(bandNum).WriteArray(array)

