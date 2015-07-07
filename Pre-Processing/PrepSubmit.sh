#$ -V
#$ -l h_rt=48:00:00
#$ -N stack
#$ -j y

module load batch_landsat/v4
cd 

landsatPrepSubmit.sh -m 10 -c 5 -s 4 -p 12.5 -l 0 -f 1 -g 1 -u 1 ./

#change -l 0 to -l 1 if you want Ledaps (LC8 for example). 
