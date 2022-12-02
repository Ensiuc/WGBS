#!/bin/bash
#
#SBATCH --time=5-00
#SBATCH --mem=100G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --partition=bigmemm # Partition to submit to
#SBATCH --output=slurmout/qmm-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/qmm-%A-%a.err # File to which STDERR will be written
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ehabibi@ucdavis.edu



start=`date +%s`
hostname

aklog
export baseP=/group/millermrgrp4/ehabibi/Methylation
export datP=${baseP}/04-Qualimap
export seqP=${baseP}/02-Cleaned
export refP=${baseP}/References
export cwd=${baseP}/scripts

module load R
module load bio3
module load samtools
module load qualimap

#n=$(wc -l allsamples.txt |cut -d' ' -f1 )

#for i in $( eval echo {1..${n}} )
#do
 # sample=$(sed "${i}q;d" allsamples.txt)
  #if [ $i -lt 4 ]
 # then
  #  grp="group_1"
 # else
  #  grp="group_2"
 # fi
 # echo -e "${sample}\t${datP}/${sample}\t${grp}" >> input.fofn
#done


qualimap multi-bamqc -d input.fofn -outdir $datP 


end=`date +%s`
runtime=$((end - start ))
echo $runtime

