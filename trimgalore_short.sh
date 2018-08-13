#PBS -S /bin/bash
#PBS -N TrimGalore4.0
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
#PBS -l walltime=12:00:00
#PBS -l mem=10gb


cd /lustre1/sb61937
module load Trim_Galore/0.4.5-foss-2016b
trim_galore --fastqc --fastqc_args "--outdir /lustre1/sb61937/TrimGalore_Fastqc/90/ -f fastq" -stringency 3 -o /lustre1/sb61937/TrimGalore_Fastqc/90/ --paired /lustre1/sb61937/rCorrector_Output/fixed_138599-90_S19_L004_R1_001.cor.fq /lustre1/sb61937/rCorrector_Output/fixed_138599-90_S19_L004_R2_001.cor.fq
