#!/bin/bash
#
#SBATCH --time=5-00
#SBATCH --mem=50G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --partition=bigmemh # Partition to submit to
#SBATCH --output=slurmout/fqcpo-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/fqcpp-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu



start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export seqP=${baseP}/02-Cleaned
export outP=${baseP}/012-Fastqc
export cwd=${baseP}/scripts
export tmpP=$cwd/tmp


if [ ! -d "${outP}" ]; then
   mkdir ${outP}
fi

if [ ! -d "${tmpP}" ]; then
   mkdir ${tmpP}
fi


module load fastqc/0.11.9

name=`head -n ${SLURM_ARRAY_TASK_ID} allsamples.txt | tail -1`


call="fastqc --dir $tmpP --outdir $outP $seqP/${name}_R1_val_1.fq.gz"
echo $call
eval $call

call="fastqc --dir $tmpP --outdir $outP $seqP/${name}_R2_val_2.fq.gz"
echo $call
eval $call


end=`date +%s`
runtime=$((end - start ))
echo $runtime


