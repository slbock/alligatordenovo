#PBS -S /bin/bash
#PBS -N HiSat2_index3.0
#PBS -q batch
#PBS -l nodes=1:ppn=2
#PBS -l walltime=48:00:00
#PBS -l mem=100gb

cd /lustre1/sb61937/STIM_READS_ALIGN
#re-downloading A. miss. reference genome
wget -O Amiss.ref.fa.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/281/125/GCF_000281125.3_ASM28112v4/GCF_000281125.3_ASM28112v4_genomic.fna.gz
gunzip Amiss.ref.fa.gz

#re-dowloading annotation file
wget -O Amiss.ref.gff.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/281/125/GCF_000281125.3_ASM28112v4/GCF_000281125.3_ASM28112v4_genomic.gff.gz
gunzip Amiss.ref.gff.gz

#using bedtools to build tables based on exons and introns

module load BEDTools/2.26.0-foss-2016b

awk 'BEGIN{OFS="\t";} $3=="exon" {print $1,$4,$5,$7}' Amiss.ref.gff > Amiss_exon.bed
sortBed -i Amiss_exon.bed > Amiss_exon_temp.bed
mv -f Amiss_exon_temp.bed Amiss_exon.bed
mergeBed -i Amiss_exon.bed > Amiss_exon_merged.bed

awk 'BEGIN{OFS="\t";} $3=="gene" {print $1,$4,$5,$7}' Amiss.ref.gff > Amiss_gene.bed
sortBed -i Amiss_gene.bed > Amiss_gene_temp.bed
mv -f Amiss_gene_temp.bed Amiss_gene.bed
subtractBed -a Amiss_gene.bed -b Amiss_exon_merged.bed > Amiss_intron.bed

#creating table of exons
awk '{if ($3=="exon") {print $1"\t"$4-1"\t"$5-1}}' Amiss.ref.gff > Amiss.ref_exonsFile.table

#using hisat2 to build index with exon and intron tables
module load HISAT2/2.1.0-foss-2016b

hisat2-build -p 2 --ss /lustre1/sb61937/STIM_READS_ALIGN/Amiss_intron.bed --exon /lustre1/sb61937/STIM_READS_ALIGN/Amiss.ref_exonsFile.table  -f /lustre1/sb61937/STIM_READS_ALIGN/Amiss.ref.fa Amiss_index
