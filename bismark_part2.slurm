#!/bin/bash
#
#SBATCH --time=5-00
#SBATCH --mem=100G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --partition=bigmemm # Partition to submit to
#SBATCH --output=slurmout/bm2-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/bm2-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu



start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export bamP=${baseP}/03-Bismark
export outP=${baseP}/04-Methylation
export seqP=${baseP}/02-Cleaned
export refP=${baseP}/References
export cwd=${baseP}/scripts
export tmpd=$cwd/tmp

if [ ! -d "${tmpd}" ]
then
  mkdir -p ${tmpd}
fi


if [ ! -d "${outP}" ]
then
   mkdir -p ${outP}
fi

if [ ! -d "${bamP}" ]
then
   mkdir -p ${bamP}
fi

module load bismark
module load samtools
module load bowtie2

name=`head -n ${SLURM_ARRAY_TASK_ID} allsamples.txt | tail -1`

# extract methylation information
bismark_methylation_extractor -p --merge_non_CpG --gzip --no_overlap --no_header --mbias_off --comprehensive --bedgraph --output ${outP} --parallel 48 --buffer_size 70G --genome_folder $refP ${bamP}/${name}.input${name}_R1_001_bismark_bt2_pe.deduplicated.bam

end=`date +%s`
runtime=$((end - start ))
echo $runtime


