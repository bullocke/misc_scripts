#This is a script for finding folders in which landsatPrepSubmit failed to perform Fmask. The tar.gz files are moved to a new folder ("redoFmask" in this case). This way landsatPrepSubmit can be run again.

cd /projectnb/landsat/projects/CMS_Mexico/images/019045/images

for img in $(find . -name 'L*' -type d); do

	cd $img
	if [ ! -f L*MTLFmask ]; 
	then
	echo $img
	cd ..
	mv $img ../redoFmask
	else
	cd ..
	fi
done 
