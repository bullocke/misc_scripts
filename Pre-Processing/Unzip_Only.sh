#!/bin/bash
#$ -V
#$ -l h_rt=24:00:00
#$ -N unzip
#$ -j y

#Change for file directory
cd /projectnb/landsat/projects/CMS_Mexico/images/018045

n=$(find ./ -maxdepth 1 -name '*tar.gz' | wc -l)
i=1

for archive in $(find ./ -maxdepth 1 -name '*tar.gz'); do
    echo "<----- $i / $n: $(basename $archive)"
    
    # Create temporary folder for storage
    mkdir temp
    
    # Extract archive to temporary folder
    tar -xzvf $archive -C temp/
    
    # Find ID based on MTL file's filename
    mtl=$(find temp/ -name 'L*MTL.txt')
    
    # Test to make sure we found it
    if [ ! -f $mtl ]; then
        echo "Could not find MTL file for $archive"
        break
    fi
    
    # Use AWK to remove _MTL.txt
    id=$(basename $mtl | awk -F '_' '{ print $1 }')
    
    # Move archive into temporary folder
    mv $archive temp/
    
    # Rename archive
    mv temp $id
    
    # Iterate count
    let i+=1
done

echo "Done!"
