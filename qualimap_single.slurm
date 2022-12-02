#!/bin/bash
#
#SBATCH --time=5-00
#SBATCH --mem=20G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --partition=high # Partition to submit to
#SBATCH --output=slurmout/qm-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/qm-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu



start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export bamP=${baseP}/03-Bismark
export seqP=${baseP}/02-Cleaned
export refP=${baseP}/References
export cwd=${baseP}/scripts


if [ ! -d "${bamP}" ]; then
   mkdir ${bamP}
fi

module load R
module load bio3
module load samtools
module load qualimap

name=`head -n ${SLURM_ARRAY_TASK_ID} allsamples.txt | tail -1`

export outP=${baseP}/04-Qualimap/${name}

if [ ! -d "${outP}" ]; then
   mkdir -p ${outP}
fi

samtools sort -@ 10 -o $bamP/${name}.input${name}_R1_001_bismark_bt2_pe.dedup.sorted.bam $bamP/${name}.input${name}_R1_001_bismark_bt2_pe.deduplicated.bam

qualimap bamqc --java-mem-size=40G -bam ${bamP}/${name}.input${name}_R1_001_bismark_bt2_pe.dedup.sorted.bam -c -oc $outP/${name}.qualimap.txt -outdir ${outP} -outfile ${name}.html -outformat html



end=`date +%s`
runtime=$((end - start ))
echo $runtime


