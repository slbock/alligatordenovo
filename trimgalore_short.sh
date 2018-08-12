#PBS -S /bin/bash
#PBS -N TrimGalore3.0
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
#PBS -l walltime=12:00:00
#PBS -l mem=10gb

cd /lustre1/sb61937
mkdir TrimGalore_Fastqc

cd TrimGalore_Fastqc
mkdir 110
cd /lustre1/sb61937
module load Trim_Galore/0.4.5-foss-2016b
trim_galore --fastqc --fastqc_args "--outdir /lustre1/sb61937/TrimGalore_Fastqc/110/ -f fastq" -stringency 3 -o /lustre1/sb61937/TrimGalore_Fastqc/110/ --paired /lustre1/sb61937/rCorrector_Output/fixed_138599-110_S27_L004_R1_001.cor.fq /lustre1/sb61937/rCorrector_Output/fixed_138599-110_S27_L004_R2_001.cor.fq
