#### This will take the exported Metadata from EarthExplorer and put them in a
#### .txt file to submit as an order to ESPA. All file names and directories need to
#### be changed accordingly. 
cd /projectnb/landsat/users/bullocke/Rondonia/232067

folder=$(basename "$PWD")
output=${folder}_submit.txt
echo "$output"

ETM=$(find . -type f -name 'L*ETM*')
ETM_base=$(basename $ETM)

TM=$(find . -type f -name 'L*_TM_*')
TM_base=$(basename $TM)

#L8=$(find . -type f -maxdepth 1 -name '*LANDSAT_8*txt')
#L8_base=$(basename $L8)

cat $ETM_base | awk -F ',' 'NR > 1 { print $2 }' > $output
cat $TM_base | awk -F ',' 'NR > 1 { print $2 }' >> $output
#cat $L8_base | awk -F ',' 'NR > 1 { print $2 }' >> $output

n=$(cat $output | wc -l)

echo "You have $n Landsat images"

rm $ETM_base
rm $TM_base
#rm $L8_base
