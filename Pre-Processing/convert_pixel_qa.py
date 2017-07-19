#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""Convert Pixel QA.

Usage:
  convert_pixel_qa.py <filename> <output> <sensor>


"""



from docopt import docopt
import gdal, ogr, osr, os
import numpy as np
from osgeo import gdal
import sys
import math


def save_raster(array, path, dst_filename, nbands):
    example = gdal.Open(path)
    x_pixels = array.shape[1]  # number of pixels in x
    y_pixels = array.shape[0]  # number of pixels in y
    driver = gdal.GetDriverByName('GTiff')
    dataset = driver.Create(dst_filename,x_pixels, y_pixels,nbands,gdal.GDT_Int32)
    dataset.GetRasterBand(1).WriteArray(array[:,:])
    geotrans=example.GetGeoTransform() 
    proj=example.GetProjection() 
    dataset.SetGeoTransform(geotrans)
    dataset.SetProjection(proj)
    dataset.FlushCache()
    dataset=None

def mask_raster(array, mask_values, replacement):
    for i in mask_values:
	array[array == i] = replacement
    return array

if __name__ == '__main__':
    args = docopt(__doc__, version='0.1.0')


path = args['<filename>']
output = args['<output>']
sensor = int(args['<sensor>'])

 
gdalData = gdal.Open(path)
mask_ar = gdalData.ReadAsArray()

if sensor in [4, 5, 7]: 
    clear=[66, 130]
    water=[68, 132]
    cloudsh=[72, 136]
    snow=[80,112,144,176]
    cloud=[96,112,160,176,224]
else:
    clear=[322,386]
    water=[324, 388, 836, 900]
    cloudsh=[328, 392, 840, 904]
    snow=[336, 368, 400, 432, 848, 880, 912, 944]
    cloud=[352, 368, 416, 432, 480, 864, 880, 928, 944, 992]

fill=[1]

outraster = mask_raster(mask_ar, clear, 0)
outraster = mask_raster(outraster, fill, 255)
outraster = mask_raster(outraster, water, 1)
outraster = mask_raster(outraster, cloudsh, 2)
outraster = mask_raster(outraster, snow, 3)
outraster = mask_raster(outraster, cloud, 4)

save_raster(outraster, path, output, 1)
