project = raw_input("Project? :")
pathrow1 = raw_input("Path Row? PPPRRR :")
parameter = raw_input("Enter of parameter file? :")
user = raw_input("User who processed scene? :")
#Print "Your Project is: %s" % (project)

from collections import OrderedDict
 
import fiona
import json
from json import *
import gdal
from osgeo import ogr
import os

pathrow2=pathrow1.lstrip("0")
 
_pr = int(pathrow2)
_project = project
_author = user
_location = parameter
 
_properties = OrderedDict([
    ['WRS2', 'int'],
    ['project', 'str'],
    ['author', 'str'],
    ['location', 'str']
])
 
_schema = {'geometry': 'Polygon',
           'properties': _properties
           }
 
 
source = fiona.open('wrs2_descending.shp')
 
for rec in source:
    if rec['properties']['WRSPR'] == _pr:
        break
 
with fiona.open('PRmap.shp') as f:
    elem=next(f)
    elem['geometry'] = rec['geometry']
    elem['properties'] = {
        'WRS2': _pr,
        'project': _project,
        'author': _author,
        'location': _location,
    }
    
import os
os.system("cp /usr3/graduate/bullocke/bin/Useful_RS_Scripts/YATSM/Map/PRmap* /usr3/graduate/bullocke/bin/Useful_RS_Scripts/YATSM/Map/tmp/")

with fiona.open('/usr3/graduate/bullocke/bin/Useful_RS_Scripts/YATSM/Map/tmp/PRmap.shp', 'a') as f:
    f.write(elem)
    
os.remove("PRmap.geojson")
os.system("ogr2ogr -f GeoJSON -t_srs crs:84 PRmap.geojson /usr3/graduate/bullocke/bin/Useful_RS_Scripts/YATSM/Map/tmp/PRmap.shp")
