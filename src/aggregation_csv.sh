#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

echo "sample_id,molecule_h5" > $1

for i in {1..8}; do
    echo SeaUrchin-scRNA-$i,SeaUrchin-scRNA-0$i/outs/molecule_info.h5 >> $1
done
