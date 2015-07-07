
#cd /projectnb/landsat/users/bullocke/yatsm/scripts
cd /projectnb/landsat/users/bullocke/yatsm_old/scripts
module load batch_landsat/v4
#for Date in 2001-237 2001-247 2001-257; do 
#for i in 2000-257 2000-265 2000-017 2000-217 2000-081 2000-097 2000-249 2000-305 2000-177 2000-145 2000-289 2000-337 2000-169 2000-281 2000-233 2000-329 2000-185 2001-123 2001-019 2001-099 2001-219 2001-179 2001-211 2001-027 2001-067; do 
#for img in $(find ../../testing/CCDC_Visualization/California -maxdepth 1 -name 'Real*A'); do
for Date in 2010-318 2010-328; do 
bn=$(basename $img)
#Date=${bn:12:8}
qsub -V -j y -b y $(which python) yatsm_map.py --root "/projectnb/landsat/users/bullocke/testing/CCDC_Visualization/Colorado/images" -i "example_img" -r YATSM -f ENVI --ndv -9999 --before --date "%Y-%j" predict $Date Pred_Col_${Date}_B

done
