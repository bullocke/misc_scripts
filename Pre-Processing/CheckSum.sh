cd /projectnb/landsat/projects/NRT_MODIS/227063
#cd /projectnb/landsat/projects/CMS_Mexico/images/020049/L8


for checksum in $(find ./ -name 'L*.cksum'); do
    # Find basename of file and remove extension to match up with archive
    bn=$(basename $checksum | awk -F '.' '{ print $1 }')
    
    # Test to see if archive exists
    archive=${bn}.tar.gz
    if [ ! -f $archive ]; then
        echo "$bn has no matching archive"
        continue
    fi
    
    # If archive exists, then validate checksum
    test=$(cksum $archive)
    if [ "$test" != "$(cat $checksum)" ]; then
        echo "!!!!! WARNING !!!!!"
        echo "$bn may be corrupted"
        echo "!!!!! WARNING !!!!!"
    else
        echo "$bn is OK"
    fi
done
