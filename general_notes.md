### General notes on Trinity de-novo transcriptome assembly pipeline

*Quality control*
  - FastQC on raw reads
  - rCorrector
    - to be continued
  - TrimGalore!
    - to be continued

*Alignment*
  - Hisat2 alignment (https://ccb.jhu.edu/software/hisat2/manual.shtml)
    - maps RNAseq reads against a single reference genome
    - in addition to using one global graph index (GFM), Hisat2 uses a large set of small GFM indexes that collectively cover the whole genome
    - these small indexes combined with several alignment strategies enable effective alignment of sequencing reads
    - Hisat2 searches for up to N distinct, primary alignments for each read, where N equals the integer specified by the -k parameter
      - primary alignments are those whose alignment score is equal or higher than any other alignments
    - Performance tuning
      - -p option launches a specified number of parallel search threads
    - Main arguments
      - -x <hisat2-idx> - base name of the index for the reference genome. Basename is the name of any of the index files up to but not including the final .1.ht2 /etc.
        - Hisat2 looks for the specified index first in the current directory, then in the directory specified in the HISAT2_INDEXES environment variable
      - -1 <m1> - comma-separated list of files containing mate 1s, must correspond file-for-file and read-for-read with those specified in <m2>
      - -2 <m2> - comma-separated list of files containing mate 2s
      - -S <hit> - file to write SAM alignments to. By default, alignments are written to the stdout
    - Input options
      - -q - Reads are FASTQ files (extension .fq or .fastq)
    - Spliced alignment options
      - --dta/--downstream-transcriptome-assembly report alignments tailored for transcript assemblers including StringTie. With this option, Hisat2 requires longer anchor lengths for de novo discovery of splice sites. This leads to fewer alignments with short-anchors, which helps transcript assemblers improve significantly in computation and memory usage

*Trinity*
  - **Intro** (from https://github.com/trinityrnaseq/trinityrnaseq/wiki)
    - Trinity assembles transcript sequences from Illumina RNA-seq data
    - Combines 3 independent software modules - Inchworm, Chrysalis, and Butterfly applied sequentially to process large volumes of RNAseq reads
    - Trinity partitions the sequence data into many individual de Bruijn graphs, each representing the transcriptional complexity at a given gene or locus
      - each graph is processed independently to extract full-length splicing isoforms and tease apart transcripts derived from paralogous genes

      [1] Inchworm assembles the RNA-seq data into the unique sequences of transcripts, often generating full-length transcripts of the dominant isoform, but then reports just the unique portions of alternatively spliced transcripts
      [2] Chrysalis clusters the inchworm contigs into clusters and constructs complete de Bruijn graphs for each cluster. Each cluster represents the full transcriptional complexity for a given gene (or sets of genes that share sequences in common). Chrysalis then partitions the full read set among these disjoint graphs.
      [3] Butterfly then processes the individual graphs in parallel, tracing the paths that reads and pairs of reads take within the graph, ultimately reporting full-length transcripts for alternatively spliced isoforms, and teasing apart transcripts that correspond to paralogous genes

  - Trinity performs best with strand-specific data, in which case sense and antisense transcripts can be resolved
    - to specify the strand-specific data, specify the library type
    ```
    --SS_lib_type RF
    ```
    - Two library types for paired reads
      1) RF - first read (/1) of fragment pair is sequenced as antisense (reverse(R)), and second read (/2) is in the sense strand (forward(F)); typical of the dUTP/UDG sequencing method
      2) FR - first read (/1) of fragment pair is sequenced as sense (forward), and second read (/2) is in the antisense strand (reverse)

  - **Genome-guided Trinity Transcriptome Assembly**
    - When a genome sequence is available, Trinity offers a method whereby reads are first aligned to the genome, partitioned according to locus, followed by de novo transcriptome assembly by each locus
      - Genome is being used as a substrate for grouping overlapping reads into clusters that will then be separately fed into Trinity for de-novo transcriptome assembly
      - Unlike typical genome-guided approaches (e.g. cufflinks), transcripts are reconstructed based on the actual read sequences
      - In comparison to genome-free de novo assembly, this approach can help in cases of paralogs or genes with shared sequences, since the genome is used to partition the reads according to locus prior to doing any de novo assembly (if you have a highly fragmented draft genome, it's better to do genome-free de novo transcriptome assembly)
    - **Question: Does genome-guided transcriptome assembly only assemble reads that map to the reference genome?** Seems like this is the case if you are only supplying Trinity with a coordinate-sorted bam file
    - To conduct genome-guided de-novo assembly, must supply Trinity with coordinate-sorted bam file
    ```
    Trinity --genome_guided_bam rnaseq.coordSorted.bam \
         --genome_guided_max_intron 10000 \
         --max_memory 10G --CPU 10
    ```
    - Must also specify the maximum intron length that makes sense for your target organism
    **Question: How do you determine an appropriate maximum intron length?**
  - **Trinity Output**
    - Trinity will create a Trinity.fasta output file in the 'trinity_out_dir/'
    - Trinity groups transcripts into clusters based on shared sequence content - loosely referred to as a 'gene'
    - Accession encodes the Trinity 'gene' and 'isoform'
    - the 'gene' identifier should be considered an aggregate of the read cluster and corresponding gene identifier
    - the path information stored in the header indicates the path traversed in the Trinity compacted de Bruijn graph to construct that transcript - node numbers are unique only in the context of a given Trinity gene identifier, and so graph nodes can be compared among isoforms to identify unique and shared sequences of each isoform of a given gene
  - **Assembly Quality Assessment**
    - Examine RNA-Seq read representation of the assembly - at least ~80% of your input RNA-seq reads are represented by your transcriptome assembly
      - **This could be especially useful in assessing the feasibility of using genome-guided de novo assembly**
    - Examine the representation of full-length reconstructed protein-coding genes, by search the assembled transcripts against a databased of known protein sequences
    - Use BUSCO to explore completeness according to conserved ortholog content
    - Compute the E90N50 transcript contig length - the contig N50 value based on the set of transcripts representing 90% of the expression data
    - Compute DETONATE scores
      - DETONATE provides a rigorous computational assessment of the quality of a transcriptome assembly.
    - TransRate also provides statistics for evaluating transcriptome assemblies
  - **Other tips**
    - The assembly typically takes ~1/2 to 1 hour per million reads - if you have a large dataset be sure to use the --normalize_reads parameter to improve run times
