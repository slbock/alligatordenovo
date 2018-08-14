#PBS -S /bin/bash
#PBS -q batch
#PBS -M samantha.bock@uga.edu
#PBS -m ae
#PBS -N rCorrector
#PBS -l nodes=1:ppn=4
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

cd /lustre1/sb61937
mkdir rCorrector_YATSU
cd rCorrector_YATSU
module load Rcorrector/1.0.2-foss-2016b

for i in DRR048609 DRR048610 DRR048611 DRR048612 DRR048613 DRR048614 DRR048615 DRR048616 DRR048617 DRR048618 DRR048619 DRR048620 DRR048621 DRR048622 DRR048623 DRR048624 DRR048625 DRR048626 DRR048627 DRR048628 DRR048634 DRR048635
do
run_rcorrector.pl -1 /lustre1/sb61937/YATSU_READS/${i}_1.fastq -2 /lustre1/sb61937/YATSU_READS/${i}_2.fastq -t 4
done
