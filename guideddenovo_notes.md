## 9/5/18

Below is a summary of the current progress towards implementing a genome-guided de-novo transcriptome assembly using reads from STIM2014
  - Included in this summary is a description of steps taken and scripts used

**GENERAL APPROACH**
  - Largely informed by "Best Practices for De Novo Transcriptome Assembly with Trinity" by Adam Freedman, Harvard FAS Informatics
    (https://informatics.fas.harvard.edu/best-practices-for-de-novo-transcriptome-assembly-with-trinity.html)
  - Steps:
    1) Examine quality metrics of STIM2014 sequencing reads using FastQC
    2) Remove erroneous k-mers from the reads using rCorrector
    3) Filter out read pairs deemed unfixable by rCorrector
    4) Trim adapter sequences from fastq files using TrimGalore
    5) Align trimmed reads to reference genome
    6) Run Trinity guided de-novo transcriptome assembly with aligned reads
    7) Evaluate transcriptome quality

*STEP 1: Examine read quality with FastQC*

  - FastQC was run on the raw STIM2014 reads (downloaded from Dropbox to local machine then copied to cluster using scp command)
      -- fastqc.sh script used for generating FastQC reports

*STEP 2: Remove erroneous kmers with rCorrector*

  - rCorrector was used to correct erroneous kmers in the raw reads
    - rcorrector.sh script was used for this.
      - There was an error with the code for sample 110. Error message "ERROR: The files are not paired!
      Failed at stage 3." indicates there is an error in the code, likely missing a file
      - Sample 110 was removed for now and will be troubleshot later

*STEP 3: Filter unfixable read pairs with python script*
    - python script FilterUncorrectabledPEfastq.py
  - (supplied by A. Freedman, https://informatics.fas.harvard.edu/best-practices-for-de-novo-transcriptome-assembly-with-trinity.html)
  - this script filters out read pairs from the rCorrector output that were unfixable
  - FilterUncorrectabledPEfastq.py was copied to the directory where the rCorrector output was located
  - then code in the FastQFilter.sh script was ran directly on the command line

*STEP 4: Trim adapter sequences with TrimGalore!*
  - TrimGalore! (wrapper for cutadapt) has been shown to be more effective at removing adapter sequences than trimmomatic, recommended by A. Freedman
    -- Using trimgalore.sh script
  - after some research and discussion with BBP, MDH, EMB, stringency set to 3 base pairs

*STEP 5: Align trimmed reads to reference genome using Hisat2*
  - Trinity genome-guided de novo transcriptome assembly requires that read alignments be supplied as a coordinate sorted .bam file
  - Initial attempt
    -- hisat2.sh script was used in my first attempt at the read alignment
    - Reference genome (GCF_000281125.3_ASM28112v4_genomic.fna.gz) and RefSeq annotation file (GCF_000281125.3_ASM28112v4_genomic.gff.gz) downloaded from NCBI
    - Used hisat2-build function to build an index with the genome and annotation file
    - HOWEVER, this code did not actually use the annotation file for the index
    - hisat2 was then used to align the reads
    - samtools was used to generate sorted bam files
    - Reads were aligned successfully but hisat2 DID NOT use the annotation file for this
  - Second attempt
    - MDH ran into this problem with the RefSeq annotation file previously and generated a workaround code to manually generate the index
    - Manually generating index with BEDTools and Hisat2
      - bedtools_hisat2_index.sh script was used for this
      - BEDTools was used to generate exon and intron tables from the annotation file
      - Then Hisat2 used these intron and exon tables to build an index with the hisat2-build function
      - This appeared to work successfully and generated 6 files with the .ht2 suffix
    - I then attempted to align reads with Hisat2 and this new index
      -- Using hisat2_align.sh script
      - This script failed and gave the error message:
      ```
      "Error reading _rstarts[] array: 2920692, 2924820
        Error: Encountered internal HISAT2 exception (#1)"
      ```
      - I thought this had something to do with the new arguments added to the hisat2 function
      - To troubleshoot, I tested part of EMB's alignment script
        -- Using hisat2_align_test.sh script
        - This script failed and gave the error message:
        ```
        "(ERR): Argument expected in next token!"
        ```
        - This error seems to indicate that there is a missing argument in the hisat2 command

## 9/6/18

Continuing to work on troubleshooting Hisat2 alignment (STEP 5) and moving forward with Trinity script (STEP 6)

*STEP 5: Align trimmed reads to reference genome using Hisat2 (CONTINUED)*
  - Examining arguments for hisat2 alignment script

*STEP 6: Run Trinity guided de-novo transcriptome assembly with aligned reads*
  - Trinity genome-guided de-novo transcriptome assembly uses the coordinate-sorted bam file generated from the alignment
  - The alignment serves to partition the reads according to locus before performing de-novo transcriptome assembly
  - Because the alignment is simply used to cluster reads by locus it is likely not critical for the annotation file to be used for the alignment
  - Thus, Trinity guided de-novo transcriptome assembly can be tested on the .bam files generated from the first alignment, while I troubleshoot the alignment with the new index
  - trinity_test.sh script used for first pass

  - trinity_final.sh script used for final run
  - results of annotation-free genome-guided transcriptome assembly:

################################
## Counts of transcripts, etc.
################################
Total trinity 'genes':	179559
Total trinity transcripts:	207272
Percent GC: 47.04

########################################
Stats based on ALL transcript contigs:
########################################

	Contig N10: 6147
	Contig N20: 4788
	Contig N30: 3784
	Contig N40: 2991
	Contig N50: 2263

	Median contig length: 353
	Average contig: 902.90
	Total assembled bases: 187146714


#####################################################
## Stats based on ONLY LONGEST ISOFORM per 'GENE':
#####################################################

	Contig N10: 5665
	Contig N20: 4176
	Contig N30: 3106
	Contig N40: 2184
	Contig N50: 1400

	Median contig length: 319
	Average contig: 697.13
	Total assembled bases: 125175477

## 9/10/18
*STEP 5: Align trimmed reads to reference genome using Hisat2 (CONTINUED)*
- Built new index from reference genome and annotation file and hisat2 alignment worked

*STEP 6: Run Trinity guided de-novo transcriptome assembly with aligned reads*
- Used samtools_sort.sh to sort resulting sam files from hisat2 alignment
- Used samtools_merge.sh to merge sorted bam files, produced single coordinate sorted bam file which was subsequently supplied to Trinity
- Basic alignment statistics for transcriptome assembly based on alignment using annotations:

################################
## Counts of transcripts, etc.
################################
Total trinity 'genes':	184798
Total trinity transcripts:	210886
Percent GC: 47.05

########################################
Stats based on ALL transcript contigs:
########################################

	Contig N10: 6107
	Contig N20: 4723
	Contig N30: 3713
	Contig N40: 2916
	Contig N50: 2191

	Median contig length: 348
	Average contig: 878.41
	Total assembled bases: 185245301


#####################################################
## Stats based on ONLY LONGEST ISOFORM per 'GENE':
#####################################################

	Contig N10: 5636
	Contig N20: 4135
	Contig N30: 3051
	Contig N40: 2138
	Contig N50: 1361

	Median contig length: 318
	Average contig: 688.38
	Total assembled bases: 127211377


*STEP 7: Evaluate transcriptome quality*

- *A) Quantified read support for transcriptome assembly by aligning reads back to the transcriptome using bowtie2*
- Basic summary of the bowtie2 alignment:

14152259 reads; of these:
  14152259 (100.00%) were paired; of these:
    4558479 (32.21%) aligned concordantly 0 times
    4602997 (32.52%) aligned concordantly exactly 1 time
    4990783 (35.26%) aligned concordantly >1 times
    ----
    4558479 pairs aligned concordantly 0 times; of these:
      664404 (14.58%) aligned discordantly 1 time
    ----
    3894075 pairs aligned 0 times concordantly or discordantly; of these:
      7788150 mates make up the pairs; of these:
        1757285 (22.56%) aligned 0 times
        1991792 (25.57%) aligned exactly 1 time
        4039073 (51.86%) aligned >1 times
93.79% overall alignment rate

- *B) Examine representation of full-length reconstructed protein-coding genes with BLAST+*
  - Built a blastable database using the SwissProt database
  - Running Blastx on 20k chunks of the genome-guided transcriptome
