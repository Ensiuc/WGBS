#!/bin/bash
#
#SBATCH --time=5-00
#SBATCH --mem=10G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --partition=high # Partition to submit to
#SBATCH --output=slurmout/mqcb-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/mqcb-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu



start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export alnP=${baseP}/03-Bismark
export metP=${baseP}/04-Methylation
export cwd=${baseP}/scripts
export tmpP=$cwd/tmp


if [ ! -d "${alnP}" ]; then
   mkdir -p ${alnP}
fi

if [ ! -d "${tmpP}" ]; then
   mkdir -p ${tmpP}
fi

module load bio3
module load multiqc


call="multiqc -l input2.fofn -m bismark -o $metP/"
echo $call
eval $call


end=`date +%s`
runtime=$((end - start ))
echo $runtime


