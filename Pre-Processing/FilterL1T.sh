cd /projectnb/landsat/users/bullocke/Congo/images
if [ ! -d L1G ]; then
    mkdir L1G/
fi

for mtl in $(find ./ -name 'L*MTL.txt'); do
    id=$(basename $(dirname $mtl))
    
    l1t=$(grep "L1T" $mtl)
    
    if [ "$l1t" == "" ]; then
        echo "$id is not L1T"
        mv $(dirname $mtl) L1G
    else
        echo "$id is L1T"
    fi
    
done
