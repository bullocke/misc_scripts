module load batch_landsat/v4

#location of the stack of images
cd /projectnb/landsat/projects/NRT_MODIS/227063/images
#What is the Path Row in all 6 digits? PPPRRR
pathrow=227063

#What is the file name pattern for how it is getting stacked?
filenames='L*sr_band1.tif; L*sr_band2.tif; L*sr_band3.tif; L*sr_band4.tif; L*sr_band5.tif; L*sr_band7.tif; L*band6.tif; L*MTLFmask' 

#What are the no data values for the bands?
noData='-9999; -9999; -9999; -9999; -9999; -9999; -9999; 255'

#What is the UTM?
utm=21

#What do you want the output fill format to be?
output='*_stack'

#What format do you want the output files to be?
format='ENVI'

#What file structure do you want?
co='INTERLEAVE=BIP'

#Now we need to loop through the images to find the extent
folders=$(find . -type f -name "L*mask" | wc -l)
echo $folders

function gdal_extent() {
    if [ -z "$1" ]; then 
        echo "Missing arguments. Syntax:"
        echo "  gdal_extent <input_raster>"
        return
    fi
    EXTENT=$(gdalinfo $1 |\
        grep "Upper Left\|Lower Right" |\
        sed "s/Upper Left  //g;s/Lower Right //g;s/).*//g" |\
        tr "\n" " " |\
        sed 's/ *$//g' |\
        tr -d "[(,]")
    echo -n "$EXTENT"
}

i=0


declare -a min_ex_a
declare -a max_ex_b
declare -a max_ex_c
declare -a min_ex_d
for img in $(find ./ -maxdepth 1 -name 'L*' -type d); do
    echo "Finding extent of $img"
    sds=$img/L*sr_band1.tif
    declare -a extent=$(gdal_extent $sds)
    ext_arr=($extent)
    min_ex_a=("${min_ex_a[@]}" ${ext_arr[0]})
    max_ex_b=("${max_ex_b[@]}" ${ext_arr[1]})
    max_ex_c=("${max_ex_c[@]}" ${ext_arr[2]})
    min_ex_d=("${min_ex_d[@]}" ${ext_arr[3]})
	
done

function mysort_a { for i in ${min_ex_a[@]}; do echo "$i"; done | sort -n; }
function mysort_b { for i in ${max_ex_b[@]}; do echo "$i"; done | sort -r -n; }
function mysort_c { for i in ${max_ex_c[@]}; do echo "$i"; done | sort -r -n; }
function mysort_d { for i in ${min_ex_d[@]}; do echo "$i"; done | sort -n; }
sorted_a=( $(mysort_a) )
sorted_b=( $(mysort_b) )
sorted_c=( $(mysort_c) )
sorted_d=( $(mysort_d) )
fin_a=${sorted_a[0]}
fin_b=${sorted_b[0]}
fin_c=${sorted_c[0]}
fin_d=${sorted_d[0]}

declare -a ext_final=($fin_a, $fin_b, $fin_c, $fin_d)
echo "The max extent is ${ext_final[@]}"
for img in $(find ./ -name L*${pathrow}198*); do echo $img; done
echo ${ext_final[@]}
max_extent=${ext_final[@]}

qsub -j y -V -l h_rt=24:00:00 -N stack_1980s /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}198*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./


qsub -j y -V -l h_rt=24:00:00 -N stack_1990 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1990*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./


qsub -j y -V -l h_rt=24:00:00 -N stack_1991 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1991*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./


qsub -j y -V -l h_rt=24:00:00 -N stack_1992 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1992*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_1993 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1993*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_1994 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1994*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_1995 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1995*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_1996 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1996*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_1997 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1997*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./


qsub -j y -V -l h_rt=24:00:00 -N stack_1998 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1998*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_1999 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}1999*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2000 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2000*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2001 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2001*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2002 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2002*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2003 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2003*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2004 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2004*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2005 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2005*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2006 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2006*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2007 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2007*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2008 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2008*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2009 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2009*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2010 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2010*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2011 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2011*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2012 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2012*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2013 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2013*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./

qsub -j y -V -l h_rt=24:00:00 -N stack_2014 /usr3/graduate/bullocke/bin/Useful_RS_Scripts/Pre-Processing/landsat_stack_v3.0.py -v -d "L*${pathrow}2014*" -n "$noData" -f "$filenames" --utm $utm -o $output --format "$format" --co "$co" --extent="$max_extent" ./ 
