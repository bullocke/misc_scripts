cd /projectnb/landsat/users/bullocke/yatsm_newest/yatsm/scripts
#cd /projectnb/landsat/users/bullocke/yatsm/scripts

module load batch_landsat/v4



python run_yatsm.py --lassocv --consecutive=4  --test_indices "2 3 4 5" \
--threshold=3 --min_rmse=100 --min_obs=12 --screening_crit=600 --plot_index=12 --plot_ylim "0 1000" --screening \
LOWESS --freq="1" --image_pattern='L*.tif' \
/projectnb/landsat/projects/fusion/br_site/data/landsat/p227r065/images/polygon_extract/subset 0 0


