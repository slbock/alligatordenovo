#PBS -S /bin/bash
#PBS -q batch
#PBS -M samantha.bock@uga.edu
#PBS -m ae
#PBS -N yatsureads1.0
#PBS -l nodes=1:ppn=4
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

#script to download reads from Yatsu 2016 and reference genome

cd /lustre1/sb61937
mkdir Alligator_reference

cd Alligator_reference
#download A. miss. reference genome
wget -O Amiss.ref.fa.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/281/125/GCF_000281125.3_ASM28112v4/GCF_000281125.3_ASM28112v4_genomic.fna.gz
gunzip Amiss.ref.fa.gz

wget -O Amiss.ref.gff.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/281/125/GCF_000281125.3_ASM28112v4/GCF_000281125.3_ASM28112v4_genomic.gff.gz
gunzip Amiss.ref.gff.gz

#convert gff to gtf
gffread Amiss.ref.gff -o Amiss.ref.gtf


cd /lustre1/sb61937/YATSU_READS
# download Amiss_day0_gonad_FPT1 from EBI as fastq: DRR048609
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048609/DRR048609_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048609/DRR048609_2.fastq.gz

# download Amiss_day0_gonad_FPT2 from EBI as fastq: DRR048610
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048610/DRR048610_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048610/DRR048610_2.fastq.gz

#download Amiss_day0_gonad_FPT3 from EBI as fastq: DRR048611
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048611/DRR048611_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048611/DRR048611_2.fastq.gz

#download Amiss_day3_gonad_FPT1 from EBI as fastq: DRR048612
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048612/DRR048612_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048612/DRR048612_2.fastq.gz

#download Amiss_day3_gonad_FPT2 from EBI as fastq: DRR048613
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048613/DRR048613_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048613/DRR048613_2.fastq.gz

#download Amiss_day3_gonad_FPT3 from EBI as fastq: DRR048614
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048614/DRR048614_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048614/DRR048614_2.fastq.gz

#download Amiss_day3_gonad_MPT1 from EBI as fastq: DRR048615
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048615/DRR048615_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048615/DRR048615_2.fastq.gz

#download Amiss_day3_gonad_MPT2 from EBI as fastq: DRR048616
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048616/DRR048616_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048616/DRR048616_2.fastq.gz

#download Amiss_day3_gonad_MPT3 from EBI as fastq: DRR048617
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048617/DRR048617_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048617/DRR048617_2.fastq.gz

#download Amiss_day6_gonad_FPT1 from EBI as fastq: DRR048618
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048618/DRR048618_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048618/DRR048618_2.fastq.gz

#download Amiss_day6_gonad_FPT2 from EBI as fastq: DRR048619
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048619/DRR048619_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048619/DRR048619_2.fastq.gz

#download Amiss_day6_gonad_FPT3 from EBI as fastq: DRR048620
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048620/DRR048620_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048620/DRR048620_2.fastq.gz

#download Amiss_day6_gonad_MPT1 from EBI as fastq: DRR048621
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048621/DRR048621_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048621/DRR048621_2.fastq.gz

#download Amiss_day6_gonad_MPT2 from EBI as fastq: DRR048622
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048622/DRR048622_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048622/DRR048622_2.fastq.gz

#download Amiss_day6_gonad_MPT3 from EBI as fastq: DRR048623
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048623/DRR048623_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048623/DRR048623_2.fastq.gz

#download Amiss_day12_gonad_FPT1 from EBI as fastq: DRR048624
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048624/DRR048624_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048624/DRR048624_2.fastq.gz

#download Amiss_day12_gonad_FPT2 from EBI as fastq: DRR048625
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048625/DRR048625_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048625/DRR048625_2.fastq.gz

#download Amiss_day12_gonad_FPT3 from EBI as fastq: DRR048626
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048626/DRR048626_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048626/DRR048626_2.fastq.gz

#download Amiss_day12_gonad_MPT1 from EBI as fastq: DRR048627
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048627/DRR048627_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048627/DRR048627_2.fastq.gz

#download Amiss_day12_gonad_MPT2 from EBI as fastq: DRR048628
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048628/DRR048628_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048628/DRR048628_2.fastq.gz

#download Amiss_day12_gonad_MPT3 from EBI as fastq: DRR048629
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048629/DRR048629_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048629/DRR048629_2.fastq.gz

#download Amiss_day18_gonad_FPT from EBI as fastq: DRR048630
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048630/DRR048630_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048630/DRR048630_2.fastq.gz

#dowload Amiss_day18_gonad_MPT from EBI as fastq: DRR048631
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048631/DRR048631_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048631/DRR048631_2.fastq.gz

#dowload Amiss_day24_gonad_FPT from EBI as fastq: DRR048632
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048632/DRR048632_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048632/DRR048632_2.fastq.gz

#dowload Amiss_day24_gonad_MPT from EBI as fastq: DRR048633
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048633/DRR048633_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048633/DRR048633_2.fastq.gz

#dowload Amiss_day30_gonad_FPT from EBI as fastq: DRR048634
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048634/DRR048634_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048634/DRR048634_2.fastq.gz

#dowload Amiss_day30_gonad_MPT from EBI as fastq: DRR048635
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048635/DRR048635_1.fastq.gz
wget ftp.sra.ebi.ac.uk/vol1/fastq/DRR048/DRR048635/DRR048635_2.fastq.gz
