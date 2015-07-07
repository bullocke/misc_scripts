#!/usr/bin/env python
""" Preprocess MODIS MOD09GA/MYD09GA and MOD09GQ/MYD09GQ

Usage:
    prep_MODIS.py [options] <input_location> <output_location>

Options:
    --pattern=<pattern>     Pattern for files to preprocess [default: M*09*hdf]
    -n --ncpu=<n>           Number of CPUs to use [default: 1]
    --nodata=<ndv>          Output NODATA value [default: -28672]
    --compression=<algo>    Compression algorithm [default: None]
    --tiled                 Create tiled TIFF files instead of stripped
    --blockxsize=<n>        X blocksize for tiles / stripes [default: None]
    --blockysize=<n>        Y blocksize for tiles / stripes [default: None]
    --resume                Do not reprocess if output file exists
    --skip_error            Skip image pair on error
    -v --verbose            Show verbose debugging options
    -q --quiet              Do not show extra information
    -h --help               Show help

"""
from __future__ import print_function, division

import fnmatch
import logging
import multiprocessing
import os
import sys

from docopt import docopt

import numexpr as ne
import numpy as np
from osgeo import gdal
import scipy.ndimage

_version = '0.1.0'

gdal.AllRegister()
gdal.UseExceptions()

logging.basicConfig(format='%(asctime)s %(levelname)s: %(message)s',
                    level=logging.INFO,
                    datefmt='%H:%M:%S')
logger = logging.getLogger(__name__)

# Product subdataset information
ga_state = 1  # 1km state flags
ga_vza = 2  # 1km view zenith angle
ga_blue = 12 # 500m blue band 
ga_green = 13  # 500m green band
ga_swir1 = 15  # 500m swir1 band
ga_qc = 17  # 500m QC band
gq_red = 1  # 250m red band
gq_nir = 2  # 250m NIR band
gq_qc = 3  # 250m QC band

compress_algos = ['LZW', 'PACKBITS', 'DEFLATE', 'None']


def find_MODIS_pairs(location, pattern='M*09*hdf'):
    """ Finds matching sets of M[OY]D09GQ and M[OY]D09GA within location

    Args:
      location (str): directory of stored data
      pattern (str, optional): glob pattern to limit search

    Returns:
      pairs (list): list of tuples containing M[OY]D09GQ and M[OY]D09GA

    """
    files = [os.path.join(location, f) for f in
             fnmatch.filter(os.listdir(location), pattern)]

    if len(files) < 2:
        raise IOError('Could not find any MODIS image pairs')

    # Parse out product and acquisition date
    products = []
    dates = []
    for f in files:
        s = os.path.basename(f).split('.')
        products.append(s[0])
        dates.append(s[1])

    products = np.array(products)
    dates = np.array(dates)

    # Retain dates if there are matching MOD09GA/MOD09GQ or MYD09GA/MYD09GQ
    pairs = []
    for d in np.unique(dates):
        i = np.where(dates == d)[0]
        prods = products[i]

        i_mod09ga = np.core.defchararray.startswith(prods, 'MOD09GA')
        i_mod09gq = np.core.defchararray.startswith(prods, 'MOD09GQ')
        i_myd09ga = np.core.defchararray.startswith(prods, 'MYD09GA')
        i_myd09gq = np.core.defchararray.startswith(prods, 'MYD09GQ')

        if i_mod09gq.sum() == 1 and i_mod09ga.sum() == 1:
            pairs.append((files[i[i_mod09gq]], files[i[i_mod09ga]]))
        if i_myd09gq.sum() == 1 and i_myd09ga.sum() == 1:
            pairs.append((files[i[i_myd09gq]], files[i[i_myd09ga]]))

    return pairs


def get_output_names(pairs, outdir):
    """ Get output filenames for pairs of MODIS images

    Output filename pattern will be:

        M[OY]D_A[YYYY][DOY]_stack.gtif

    Args:
      pairs (list): list of tuples containing M[OY]D09GQ and M[OY]D09GA
      outdir (str): output directory

    Returns:
      output (list): list of output filenames

    """
    output_names = []
    for pair in pairs:
        _temp = os.path.basename(pair[0]).split('.')
        out_name = _temp[0][0:3] + '_' + _temp[1] + '_stack.gtif'
        output_names.append(os.path.join(outdir, out_name))

    return output_names


def check_resume(pairs, output):
    """ Returns pairs and output with pre-existing results removed

    Args:
      pairs (list): list of tuples containing M[OY]D09GQ and M[OY]D09GA
      output (list): list of output filenames for each entry in pairs

    Returns:
      pairs, output (tuple): pairs and outputs with pre-existing files removed

    """
    out_pairs = []
    out_output = []
    for p, o in zip(pairs, output):
        if os.path.isfile(o):
            try:
                ds = gdal.Open(o, gdal.GA_ReadOnly)
                ds = None
            except:
                logger.warning('File {f} already exists but cannot be opened. \
                    Overwriting'.format(f=o))
            else:
                logger.debug('Skipping output {f}'.format(f=o))
                continue
        out_pairs.append(p)
        out_output.append(o)

    return (out_pairs, out_output)


def create_stack(pair, output, ndv=-28672, compression='None',
                 tiled=False, blockxsize=None, blockysize=None):
    """ Create output stack from MODIS image pairs (M[OY]D09GQ & M[OY]D09GA)

    Args:
      pair (tuple): pairs of images (M[OY]D09GQ & M[OY]D09GA)
      output (str): location to output stack
      ndv (int, optional): NoDataValue for output
      compression (str, optional): compression algorithm to use
      tiled (bool, optional): use tiles instead of stripes
      blockxsize (int, optional): tile width
      blockysize (int, optional): tile or strip height

    Stack will be formatted as:
        Band        Definition
        ----------------------
        1           Simple ratio (SR) * 1000
        2           Normalized Difference Vegetation Index (NDVI) * 10000
        3           250m red from M[OY]D09GQ
        4           250m NIR from M[OY]D09GQ
        5           500m blue from M[OY]D09GA
        6           500m green from M[OY]D09GA
        7           500m SWIR1 from M[OY]D09GA
        8           Enhanced Vegetation Index (EVI) * 10000
        9           Backup Enhanced Vegetation Index 2 (EVI2) * 10000
        10           1000m Mask band from M[OY]D09GA
        11           1000m VZA * 100 from M[OY]D09GA

    Mask values     Definition
    --------------------------
        0           Not-clear, or not-land surface

    """
    # Outut band descriptions
    bands = ['NDVI * 10000',
             '250m Red * 10000', '250m NIR * 10000',
             '500m green * 10000', '500m SWIR1 * 10000',
             'EVI * 10000',
             '1km QAQC Mask', '1km VZA * 100']
    # Open and find subdatasets
    gq_ds = gdal.Open(pair[0], gdal.GA_ReadOnly)
    ga_ds = gdal.Open(pair[1], gdal.GA_ReadOnly)

    # Read in datasets
    ds_red = gdal.Open(gq_ds.GetSubDatasets()[gq_red][0], gdal.GA_ReadOnly)
    ds_nir = gdal.Open(gq_ds.GetSubDatasets()[gq_nir][0], gdal.GA_ReadOnly)

    ds_blue = gdal.Open(ga_ds.GetSubDatasets()[ga_blue][0], gdal.GA_ReadOnly)
    ds_state = gdal.Open(ga_ds.GetSubDatasets()[ga_state][0], gdal.GA_ReadOnly)
    ds_vza = gdal.Open(ga_ds.GetSubDatasets()[ga_vza][0], gdal.GA_ReadOnly)
    ds_green = gdal.Open(ga_ds.GetSubDatasets()[ga_green][0], gdal.GA_ReadOnly)
    ds_swir1 = gdal.Open(ga_ds.GetSubDatasets()[ga_swir1][0], gdal.GA_ReadOnly)

    # Setup options
    opts = []
    if tiled:
        opts.append('TILED=YES')

    if blockxsize and tiled:
        opts.append('BLOCKXSIZE=%s' % blockxsize)
    if blockysize:
        opts.append('BLOCKYSIZE=%s' % blockysize)

    if compression:
        opts.append('COMPRESS=%s' % compression)
        if compression == 'LZW':
            opts.append('PREDICTOR=2')

    # Create file and setup metadata
    driver = gdal.GetDriverByName('GTiff')

    out_ds = driver.Create(output,
                           ds_red.RasterYSize, ds_red.RasterXSize, 8,
                           gdal.GDT_Int16,
                           options=opts)

    out_ds.SetProjection(ds_red.GetProjection())
    out_ds.SetGeoTransform(ds_red.GetGeoTransform())

    out_ds.SetMetadata(ga_ds.GetMetadata())
    out_ds.GetRasterBand(1).SetNoDataValue(-28672)

    # Write out image
    red = ds_red.GetRasterBand(1).ReadAsArray().astype(np.int16)
    nir = ds_nir.GetRasterBand(1).ReadAsArray().astype(np.int16)
    blue = enlarge(ds_blue.GetRasterBand(1).ReadAsArray().astype(np.int16),
                    2)
    green = enlarge(ds_green.GetRasterBand(1).ReadAsArray().astype(np.int16),
                    2)
    swir1 = enlarge(ds_swir1.GetRasterBand(1).ReadAsArray().astype(np.int16),
                    2)

    # Calculate SR and NDVI, masking invalid values
    eqn = '(red <= 0) | (red >= 10000) | (nir <= 0) | (nir >= 10000) | ' \
        '(green <= 0) | (green >= 10000) | (swir1 <= 0) | (swir1 >= 10000) | ' \
        '(blue <= 0) | (blue >= 10000)'
    invalid = ne.evaluate(eqn)

    sr = ne.evaluate('red / nir * 1000').astype(np.int16)
    ndvi = ne.evaluate('(nir - red) / (nir + red) * 10000').astype(np.int16)
    evi = ne.evaluate('(2.5*((nir - red)/(nir + (6 * red) - (7.5 * blue) + 10000))) * 10000').astype(np.int16)


    # Apply valid range mask to data
    blue[invalid] = ndv
    red[invalid] = ndv
    nir[invalid] = ndv
    green[invalid] = ndv
    swir1[invalid] = ndv

    # Write out
    out_ds.GetRasterBand(1).WriteArray(ndvi)
    out_ds.GetRasterBand(2).WriteArray(red)
    out_ds.GetRasterBand(3).WriteArray(nir)
    out_ds.GetRasterBand(4).WriteArray(green)
    out_ds.GetRasterBand(5).WriteArray(swir1)
    out_ds.GetRasterBand(6).WriteArray(evi)

    # Perform masking -- 1 for land and VZA in separate band
    mask = get_mask(ds_state.GetRasterBand(1).ReadAsArray()).astype(np.int16)
    out_ds.GetRasterBand(7).WriteArray(enlarge(mask, 4))

    vza = ds_vza.GetRasterBand(1).ReadAsArray().astype(np.int16)
    out_ds.GetRasterBand(8).WriteArray(enlarge(vza, 4))

    # Write data
    for i, desc in enumerate(bands):
        out_ds.GetRasterBand(i + 1).SetDescription(desc)
        out_ds.GetRasterBand(i + 1).SetMetadataItem('Description', desc)

    # Close
    ga_ds = None
    gq_ds = None

    ds_red = None
    ds_nir = None
    ds_vza = None
    ds_state = None
    ds_green = None
    ds_swir1 = None
    ds_blue = None

    out_ds = None


def get_mask(modQA, dilate=1):
    """ Return a mask image from an input QA band from M[OY]D09G[AQ]

    Args:
      modQA (ndarray): input QA/QC band image
      dilate (int, optional): pixels around aerosols and clouds to buffer

    Returns:
      mask (ndarray): output mask image with only good observations masked

    Porting note:
        MATLAB's 'bitshift' shifts to the left

    """
    # Identify land from water
    land = (np.mod(np.right_shift(modQA, 3) + 6, 8) / 7).astype(np.uint8)
    # Identify cloud
    cloud = (np.mod(modQA, 8) |  # unsure!
             np.mod(np.right_shift(modQA, 8), 4) |  # cirrus == '00' (none)
             np.mod(np.right_shift(modQA, 10), 2) |  # cloud mask == '0'
             np.mod(np.right_shift(modQA, 13), 2)) > 0  # adjacent to cloud

    cloud_buffer = scipy.ndimage.morphology.binary_dilation(
        cloud, structure=np.ones((dilate, dilate)))

    return ((cloud_buffer == 0) * land)


def enlarge(array, scaling):
    """ Enlarge an array by a scaling factor

    Args:
      array (ndarray): array to be scaled
      scaling (int): amount of scaling

    Returns:
      scaled (ndarray): scaled array

    """
    return np.kron(array, np.ones((scaling, scaling)))


if __name__ == '__main__':
    args = docopt(__doc__, version=_version)

    logger.setLevel(logging.INFO)
    if args['--quiet']:
        logger.setLevel(logging.WARNING)
    if args['--verbose']:
        logger.setLevel(logging.DEBUG)

    location = args['<input_location>']
    outdir = args['<output_location>']
    if not os.path.isdir(outdir):
        # Make output directory
        try:
            os.makedirs(outdir)
        except:
            if os.path.isdir(outdir):
                pass
            else:
                logger.error('Output directory does not exist and could '
                             'not create output directory')
                raise

    # Optional arguments
    pattern = args['--pattern']

    ndv = int(args['--nodata'])

    resume = args['--resume']

    skip_error = args['--skip_error']

    compression = args['--compression']
    if compression.lower() == 'none':
        compression = None
    else:
        if compression not in compress_algos:
            logger.error('Unknown compression algorithm. Available are:')
            for _algo in compress_algos:
                logger.error('    %s' % _algo)
            sys.exit(1)

    tiled = args['--tiled']

    blockxsize = args['--blockxsize']
    if blockxsize.lower() == 'none':
        blockxsize = None
    else:
        blockxsize = int(blockxsize)

    blockysize = args['--blockysize']
    if blockysize.lower() == 'none':
        blockysize = None
    else:
        blockysize = int(blockysize)

    ncpu = int(args['--ncpu'])
    if ncpu > 1:
        logger.warning('NCPU only supported for `numexpr` so far...')
    ne.set_num_threads(ncpu)

    logger.debug('Finding pairs of MODIS data')

    pairs = find_MODIS_pairs(location, pattern)
    output_names = get_output_names(pairs, outdir)

    logger.info('Found {n} pairs of M[OY]D09GQ and M[OY]D09GA'.format(
        n=len(pairs)))

    if resume:
        pairs, output_names = check_resume(pairs, output_names)
        logger.info('Resuming calculation for {n} files'.format(n=len(pairs)))

    failed = 0
    for i, (p, o) in enumerate(zip(pairs, output_names)):
        logger.info('Stacking {i} / {n}: {p}'.format(
            i=i, n=len(pairs), p=os.path.basename(p[0])))
        try:
            create_stack(p, o,
                         ndv=ndv, compression=compression,
                         tiled=tiled,
                         blockxsize=blockxsize, blockysize=blockysize)
        except RuntimeError:
            if skip_error:
                logger.error('Could not preprocess pair: {p1} {p2}'.format(
                    p1=p[0], p2=p[1]))
                failed += 1
            else:
                raise

    if failed != 0:
        logger.error('Could not process {n} pairs'.format(n=failed))
    logger.info('Complete')
