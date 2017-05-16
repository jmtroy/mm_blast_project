#!/bin/bash

# report counts
# This script reports data that can then be pasted in to an R markdown document.



NAME="BLAST_FILE_A30C_E"
OUTPUT_FLDR="/home/groups/simons/Joe/mm_blast_project/20170109_run_blastx_with_intergenic_intragenic_exons/output_A30C_intERgenic_blastx_RUN_20170117_203327"
echo "- data for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts.gtf | wc -l
echo "unique exons for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats.bed | wc -l
echo "unique exons for $NAME after filtering for repeats"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats_pseudo_genes_and_rpkm.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes and exons with < 1 RPKM"



NAME="BLAST_FILE_A30C_I"
OUTPUT_FLDR="/home/groups/simons/Joe/mm_blast_project/20170109_run_blastx_with_intergenic_intragenic_exons/output_A30C_intRAgenic_blastx_RUN_20170119_111155"
echo "- data for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts.gtf | wc -l
echo "unique exons for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats.bed | wc -l
echo "unique exons for $NAME after filtering for repeats"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats_pseudo_genes_and_rpkm.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes and exons with < 1 RPKM"



NAME="BLAST_FILE_FC30C_E"
OUTPUT_FLDR="/home/groups/simons/Joe/mm_blast_project/20170109_run_blastx_with_intergenic_intragenic_exons/output_FC30C_intERgenic_blastx_RUN_20170117_203417"
echo "- data for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts.gtf | wc -l
echo "unique exons for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats.bed | wc -l
echo "unique exons for $NAME after filtering for repeats"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats_pseudo_genes_and_rpkm.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes and exons with < 1 RPKM"


NAME="BLAST_FILE_FC30C_I"
OUTPUT_FLDR="/home/groups/simons/Joe/mm_blast_project/20170109_run_blastx_with_intergenic_intragenic_exons/output_FC30C_intRAgenic_blastx_RUN_20170119_111320"
echo "- data for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts.gtf | wc -l
echo "unique exons for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats.bed | wc -l
echo "unique exons for $NAME after filtering for repeats"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats_pseudo_genes_and_rpkm.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes and exons with < 1 RPKM"


NAME="BLAST_FILE_H30C_E"
OUTPUT_FLDR="/home/groups/simons/Joe/mm_blast_project/20170109_run_blastx_with_intergenic_intragenic_exons/output_H30C_intERgenic_blastx_RUN_20170124_161245"
echo "- data for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts.gtf | wc -l
echo "unique exons for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats.bed | wc -l
echo "unique exons for $NAME after filtering for repeats"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes"
echo "-"
cat "$OUTPUT_FLDR"/intergenic_transcripts_filtered_for_repeats_pseudo_genes_and_rpkm.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes and exons with < 1 RPKM"


NAME="BLAST_FILE_H30C_I"
OUTPUT_FLDR="/home/groups/simons/Joe/mm_blast_project/20170109_run_blastx_with_intergenic_intragenic_exons/output_H30C_intRAgenic_blastx_RUN_20170124_161328"
echo "- data for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts.gtf | wc -l
echo "unique exons for $NAME"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats.bed | wc -l
echo "unique exons for $NAME after filtering for repeats"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes"
echo "-"
cat "$OUTPUT_FLDR"/intRAgenic_transcripts_filtered_for_repeats_pseudo_genes_and_rpkm.bed | wc -l
echo "unique exons for $NAME after filtering for repeats and pseudo genes and exons with < 1 RPKM"


