#!/bin/bash
#
#SBATCH --time=5-00:00:00
#SBATCH --mem=30G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --partition=bigmemm # Partition to submit to
#SBATCH --output=slurmout/bm1-1-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/bm1-1-%A-%a.err # File to which STDERR will be written
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

cd $bamP

#create soft link for qced read fastq files
#ln -s ${seqP}/${name}_R1_val_1_mg.fq.gz ./input${name}_R1_001.fq.gz
#ln -s ${seqP}/${name}_R2_val_2_mg.fq.gz ./input${name}_R2_001.fq.gz

#bismark alignment
bismark --bowtie2 -p 20 --output_dir $bamP --rg_tag --rg_id ${name} --rg_sample ${name} --prefix ${name} --unmapped --temp_dir ${tmpd} --phred33-quals --fastq --genome_folder $refP -1 input${name}_R1_001.fq.gz -2 input${name}_R2_001.fq.gz > $bamP/${name}.bismark.out

# bismark deduplicate
deduplicate_bismark --bam --paired --output_dir ./ ${name}.input${name}_R1_001_bismark_bt2_pe.bam

# bismark M bias
bismark_methylation_extractor -p --merge_non_CpG --gzip --no_overlap --mbias_only --output ${outP} --parallel 48 --buffer_size 72G --genome_folder $refP ${bamP}/${name}.input${name}_R1_001_bismark_bt2_pe.deduplicated.bam

# generate bismark reports
bismark2report --dir $outP --output ${name}.bismark.report.html --alignment_report $bamP/${name}.input${name}_R1_001_bismark_bt2_PE_report.txt --dedup_report $bamP/${name}.input${name}_R1_001_bismark_bt2_pe.deduplication_report.txt --splitting_report $outP/${name}.input${name}_R1_001_bismark_bt2_pe.deduplicated_splitting_report.txt --mbias_report $outP/${name}.input${name}_R1_001_bismark_bt2_pe.deduplicated.M-bias.txt


end=`date +%s`
runtime=$((end - start ))
echo $runtime


