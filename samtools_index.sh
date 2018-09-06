#PBS -S /bin/bash
#PBS -N SAMtools1.0
#PBS -M samantha.bock@uga.edu
#PBS -q batch
#PBS -l nodes=1:ppn=1:AMD
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

cd /lustre1/sb61937/YATSU_READS_postqc

module load SAMtools/1.6-foss-2016b

for i in DRR048609 DRR048610 DRR048611 DRR048612 DRR048613 DRR048614 DRR048615 DRR048616 DRR048617 DRR048618 DRR048619 DRR048620 DRR048621 DRR048622 DRR048623 DRR048625 DRR048626 DRR048628 DRR048634 DRR048635
do
  #default settings of the index function create .bai file
samtools index ${i}.sort.bam
done
