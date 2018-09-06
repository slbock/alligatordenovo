#PBS -S /bin/bash
#PBS -N HiSat2_align3.0
#PBS -M samantha.bock@uga.edu
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

#this script aligns reads using hisat2 and a re-vamped index that actually uses the RefSeq annotation files

cd /lustre1/sb61937/STIM_READS_ALIGN

module load HISAT2/2.1.0-foss-2016b
module load SAMtools/1.6-foss-2016b

for i in fixed_138599-110_S27_L001 fixed_138599-110_S27_L002 fixed_138599-110_S27_L003 fixed_138599-134_S21_L001 fixed_138599-134_S21_L002 fixed_138599-134_S21_L003 fixed_138599-134_S21_L004 fixed_138599-23_S22_L001 fixed_138599-23_S22_L002 fixed_138599-23_S22_L003 fixed_138599-23_S22_L004 fixed_138599-63_S23_L001 fixed_138599-63_S23_L002 fixed_138599-63_S23_L003 fixed_138599-63_S23_L004 fixed_138599-68_S18_L001 fixed_138599-68_S18_L002 fixed_138599-68_S18_L003 fixed_138599-68_S18_L004 fixed_138599-69_S24_L001 fixed_138599-69_S24_L002 fixed_138599-69_S24_L003 fixed_138599-69_S24_L004 fixed_138599-8_S15_L001 fixed_138599-8_S15_L002 fixed_138599-8_S15_L003 fixed_138599-8_S15_L004 fixed_138599-90_S19_L001 fixed_138599-90_S19_L002 fixed_138599-90_S19_L003 fixed_138599-90_S19_L004
do
  # map the RNA-seq reads to the reference genome using hisat2
  # k option set to 1 means hisat searches for at most 1 distinct primary alignment for each read
   hisat2 -p 4 -q --dta -x Amiss_index -1 ${i}_R1_001.cor_val_1.fq -2 ${i}_R2_001.cor_val_2.fq k -1 | samtools view -b - > ${i}.bam

  #sort BAM files
  samtools sort -@ $THREADS -O bam -T ${i}.tmp ${i}.bam > ${i}.sort.bam
done
