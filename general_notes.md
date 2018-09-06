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

    ```
    ###############################################################################
 #
 #     ______  ____   ____  ____   ____  ______  __ __
 #    |      ||    \ |    ||    \ |    ||      ||  |  |
 #    |      ||  D  ) |  | |  _  | |  | |      ||  |  |
 #    |_|  |_||    /  |  | |  |  | |  | |_|  |_||  ~  |
 #      |  |  |    \  |  | |  |  | |  |   |  |  |___, |
 #      |  |  |  .  \ |  | |  |  | |  |   |  |  |     |
 #      |__|  |__|\_||____||__|__||____|  |__|  |____/
 #
 ###############################################################################
 #
 # Required:
 #
 #  --seqType <string>      :type of reads: ( fa, or fq )
 #
 #  --max_memory <string>      :suggested max memory to use by Trinity where limiting can be enabled. (jellyfish, sorting, etc)
 #                            provided in Gb of RAM, ie.  '--max_memory 10G'
 #
 #  If paired reads:
 #      --left  <string>    :left reads, one or more file names (separated by commas, not spaces)
 #      --right <string>    :right reads, one or more file names (separated by commas, not spaces)
 #
 #  Or, if unpaired reads:
 #      --single <string>   :single reads, one or more file names, comma-delimited (note, if single file contains pairs, can use flag: --run_as_paired )
 #
 #  Or,
 #      --samples_file <string>         tab-delimited text file indicating biological replicate relationships.
 #                                   ex.
 #                                        cond_A    cond_A_rep1    A_rep1_left.fq    A_rep1_right.fq
 #                                        cond_A    cond_A_rep2    A_rep2_left.fq    A_rep2_right.fq
 #                                        cond_B    cond_B_rep1    B_rep1_left.fq    B_rep1_right.fq
 #                                        cond_B    cond_B_rep2    B_rep2_left.fq    B_rep2_right.fq
 #
 #                      # if single-end instead of paired-end, then leave the 4th column above empty.
 #
 ####################################
 ##  Misc:  #########################
 #
 #  --SS_lib_type <string>          :Strand-specific RNA-Seq read orientation.
 #                                   if paired: RF or FR,
 #                                   if single: F or R.   (dUTP method = RF)
 #                                   See web documentation.
 #
 #  --CPU <int>                     :number of CPUs to use, default: 2
 #  --min_contig_length <int>       :minimum assembled contig length to report
 #                                   (def=200)
 #
 #  --long_reads <string>           :fasta file containing error-corrected or circular consensus (CCS) pac bio reads
 #
 #  --genome_guided_bam <string>    :genome guided mode, provide path to coordinate-sorted bam file.
 #                                   (see genome-guided param section under --show_full_usage_info)
 #
 #  --jaccard_clip                  :option, set if you have paired reads and
 #                                   you expect high gene density with UTR
 #                                   overlap (use FASTQ input file format
 #                                   for reads).
 #                                   (note: jaccard_clip is an expensive
 #                                   operation, so avoid using it unless
 #                                   necessary due to finding excessive fusion
 #                                   transcripts w/o it.)
 #
 #  --trimmomatic                   :run Trimmomatic to quality trim reads
 #                                        see '--quality_trimming_params' under full usage info for tailored settings.
 #                                  
 #
 #  --no_normalize_reads            :Do *not* run in silico normalization of reads. Defaults to max. read coverage of 50.
 #                                       see '--normalize_max_read_cov' under full usage info for tailored settings.
 #                                       (note, as of Sept 21, 2016, normalization is on by default)
 #
 #     
 #
 #  --output <string>               :name of directory for output (will be
 #                                   created if it doesn't already exist)
 #                                   default( your current working directory: "/Users/bhaas/GITHUB/trinityrnaseq/trinity_out_dir"
 #                                    note: must include 'trinity' in the name as a safety precaution! )
 #  
 #  --full_cleanup                  :only retain the Trinity fasta file, rename as ${output_dir}.Trinity.fasta
 #
 #  --cite                          :show the Trinity literature citation
 #
 #  --version                       :reports Trinity version (BLEEDING_EDGE) and exits.
 #
 #  --show_full_usage_info          :show the many many more options available for running Trinity (expert usage).
 #
 #
 ###############################################################################
 #
 #  *Note, a typical Trinity command might be:
 #
 #        Trinity --seqType fq --max_memory 50G --left reads_1.fq  --right reads_2.fq --CPU 6
 #
 #
 #    and for Genome-guided Trinity:
 #
 #        Trinity --genome_guided_bam rnaseq_alignments.csorted.bam --max_memory 50G
 #                --genome_guided_max_intron 10000 --CPU 6
 #
 #     see: /Users/bhaas/GITHUB/trinityrnaseq/sample_data/test_Trinity_Assembly/
 #          for sample data and 'runMe.sh' for example Trinity execution
 #
 #     For more details, visit: http://trinityrnaseq.github.io
 #
 ###############################################################################
 ```

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
