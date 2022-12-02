#!/bin/bash 
#
#SBATCH --time=5-00
#SBATCH --mem=50G# Memory pool for all cores (see also --mem-per-cpu)
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
export outP=${baseP}/02-Cleaned
export cwd=${baseP}/scripts


if [ ! -d "${outP}" ]; then
   mkdir ${outP}
fi

module load python
module load bio3
module load samtools #version 1.9 #script version was 2. ... 
module load bowtie2/2.4.2
module load trim_galore #version 1 #script version was 0.6.6
module load cutadapt  #version 1.8 was available ob farm, script version was 2. ... 

#source activate cutadapt-2.10  -j ${SLURM_NTASKS} 

name=`head -n ${SLURM_ARRAY_TASK_ID} allsamples.txt | tail -1`


  R1=$(ls $seqP/${name}_*.fastq.gz |grep "_R1." - )
  R2=$(ls $seqP/${name}_*.fastq.gz |grep "_R2." - )

  call="trim_galore ${R1} ${R2} --paired -q 30 --stringency 5 --phred33 -e 0.1 --length 20 \
        --clip_R1 10 --clip_R2 20 --three_prime_clip_R1 10 --three_prime_clip_R2 15 \
        --output_dir $outP"
  echo $call
  eval $call


end=`date +%s`
runtime=$((end - start ))
echo $runtime


