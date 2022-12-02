#!/bin/bash
#
#SBATCH --time=1-00
#SBATCH --mem=5G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --partition=bigmemm # Partition to submit to
#SBATCH --account=millermrgrp
#SBATCH --output=slurmout/gp-%N-%j.out # File to which STDOUT will be written
#SBATCH --error=slurmout/gp-%N-%j.err # File to which STDERR will be written

export baseP=/home/ehabibi/projects/DS-epigenetics/Methylation
export bamP=${baseP}/03-Bismark
export seqP=${baseP}/02-Cleaned
export refP=${baseP}/References
export cwd=${baseP}/scripts


if [ ! -d "${outP}" ]; then
   mkdir ${outP}
fi

if [ ! -d "${bamP}" ]; then
   mkdir ${bamP}
fi

module load bismark
module load bowtie2

bismark_genome_preparation --bowtie2 $refP

