/projectnb/landsat/datasets/MODIS/h12v09/CCDC
module load batch_landsat/v4

njob=150
for job in $(seq 1 $njob); do
    qsub -j y -V -l h_rt=48:00:00 -N yatsm_$job -b y $(which python) -u /projectnb/landsat/users/bullocke/yatsm_newest/yatsm/scripts/line_yatsm.py --resume -v h12v09_params.ini.ini $job $njob
  done
