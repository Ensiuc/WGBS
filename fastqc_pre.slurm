#!/bin/bash -l
#
#SBATCH --time=3-00
#SBATCH --mem=200G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --ntasks=8
#SBATCH --partition=bigmemh # Partition to submit to
#SBATCH --output=slurmout/fqcp-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/fqcp-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu
start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export seqP=${baseP}/00-RawData
export outP=${baseP}/011-Fastqc
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


call="fastqc -t ${SLURM_NTASKS} --dir $tmpP --outdir $outP $seqP/${name}_R1.fastq.gz"
echo $call
eval $call

call="fastqc -t ${SLURM_NTASKS} --dir $tmpP --outdir $outP $seqP/${name}_R2.fastq.gz"
echo $call
eval $call


end=`date +%s`
runtime=$((end - start ))
echo $runtime


