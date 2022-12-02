#!/bin/bash
#
#SBATCH --time=5-00
#SBATCH --mem=10G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --partition=bigmemm # Partition to submit to
#SBATCH --output=slurmout/mqcp-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/mqcp-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu



start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export seqP=${baseP}/00-RawData
export outP=${baseP}/012-Fastqc
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

call="multiqc -o $outP/ -f $outP/*_fastqc.zip"
echo $call
eval $call


end=`date +%s`
runtime=$((end - start ))
echo $runtime


