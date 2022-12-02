#!/bin/bash
#
#SBATCH --time=3-00
#SBATCH --mem=10G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --ntasks=8
#SBATCH --partition=bigmemm # Partition to submit to
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


module load multiqc/1.9
module load bio3


call="multiqc -f -o $outP/ $outP/*_fastqc.zip"
echo $call
eval $call


end=`date +%s`
runtime=$((end - start ))
echo $runtime


