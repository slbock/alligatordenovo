#PBS -S /bin/bash
#PBS -N TrimGalore6.0
#PBS -q batch
#PBS -l nodes=1:ppn=4:AMD
#PBS -l walltime=24:00:00
#PBS -l mem=20gb


cd /lustre1/sb61937
mkdir TrimGalore_YATSU
module load Trim_Galore/0.4.5-foss-2016b
for i in DRR048609 DRR048610 DRR048611 DRR048612 DRR048613 DRR048614 DRR048615 DRR048616 DRR048617 DRR048618 DRR048619 DRR048620 DRR048621 DRR048622 DRR048623 DRR048624 DRR048625 DRR048626 DRR048627 DRR048628 DRR048634 DRR048635
do
  trim_galore --fastqc --fastqc_args "--outdir /lustre1/sb61937/TrimGalore_YATSU/ -f fastq" -stringency 3 -o /lustre1/sb61937/TrimGalore_YATSU/ --paired /lustre1/sb61937/rCorrector_YATSU/fixed_${i}_1.cor.fq /lustre1/sb61937/rCorrector_YATSU/fixed_${i}_2.cor.fq
done
