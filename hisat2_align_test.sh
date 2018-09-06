#PBS -S /bin/bash
#PBS -N HiSat2_align2.0
#PBS -M samantha.bock@uga.edu
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

#this script aligns reads using hisat2 and a re-vamped index that actually uses the RefSeq annotation files

cd /lustre1/sb61937/STIM_READS_ALIGN

module load HISAT2/2.1.0-foss-2016b
module load SAMtools/1.6-foss-2016b


hisat2 -p 4 -q --dta -x Amiss_index -1 fixed_138599-134_S21_L001_R1_001.cor_val_1.fq,fixed_138599-134_S21_L002_R1_001.cor_val_1.fq,fixed_138599-134_S21_L003_R1_001.cor_val_1.fq,fixed_138599-134_S21_L004_R1_001.cor_val_1.fq -2 fixed_138599-134_S21_L001_R2_001.cor_val_2.fq,fixed_138599-134_S21_L002_R2_001.cor_val_2.fq,fixed_138599-134_S21_L003_R2_001.cor_val_2.fq,fixed_138599-134_S21_L004_R2_001.cor_val_2.fq -S 134.sam
