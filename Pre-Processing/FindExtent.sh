module load batch_landsat/v4

cd /projectnb/landsat/users/bullocke/testing/stacking

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

band_names="*band1.tif *band2.tif *band3.tif *band4.tif *band5.tif *band6.tif
*band7.tif *MTLFmask"

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

declare -a ext_final=($fin_a $fin_b $fin_c $fin_d)
echo "The max extent is ${ext_final[@]}"
for img in $(find ./ -name L*${pathrow}198*); do echo $img; done
