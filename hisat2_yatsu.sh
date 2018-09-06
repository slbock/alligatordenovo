#PBS -S /bin/bash
#PBS -N HiSat2_2.0
#PBS -M samantha.bock@uga.edu
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

THREADS=4

cd /lustre1/sb61937/YATSU_READS_postqc

module load HISAT2/2.1.0-foss-2016b
module load SAMtools/1.6-foss-2016b


for i in DRR048609 DRR048610 DRR048611 DRR048612 DRR048613 DRR048614 DRR048615 DRR048616 DRR048617 DRR048618 DRR048619 DRR048620 DRR048621 DRR048622 DRR048623 DRR048624 DRR048625 DRR048626 DRR048627 DRR048628 DRR048634 DRR048635
do
  # map the RNA-seq reads to the reference genome using hisat2
  # k option set to 1 means hisat searches for at most 1 distinct primary alignment for each read
  hisat2 -x Amiss.ref -1 fixed_${i}_1.cor_val_1.fq -2 fixed_${i}_2.cor_val_2.fq -k 1 | samtools view -b - > ${i}.bam

  #sort BAM files
  samtools sort -@ $THREADS -O bam -T ${i}.tmp ${i}.bam > ${i}.sort.bam
done
