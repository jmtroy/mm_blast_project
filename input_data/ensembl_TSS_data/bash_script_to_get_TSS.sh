#!/bin/bash

# gen TSS from ensemble archive (NCBI37)

# steps

# 1 call R script (biomaRt script) to get data from ensembl archive data

# below are the columns retrieved
# row_id
# chromosome_name
# transcript_start
# transcript_end
# ensembl_gene_id
# ensembl_transcript_id
# strand
# external_gene_id
# external_transcript_id
# transcript_biotype
# source
# status
# transcript_status
# and added in step 2 is the TSS

# note: -v OFS="\t" '{print NF}' can be used to check that a file has the expected
# number of columns for example:
# tail -n +2 temp.txt | awk -v OFS="\t" '{print NF}' | sort -u 
# should return 13


# 2 based on the strand of the transcript, determine a TSS

# 3 rearrange columns to form a proper bed file per 
# https://genome.ucsc.edu/FAQ/FAQformat#format1
# this includes removing the header and also saving the header in a separate column

# 4 create BED column header

# Let's go...

# 1 call R script (biomaRt script) to get data from ensembl archive data
# importantly this data will include the transcription starts and ends 
# of all mouse transcripts
# note: this data has chromosomes indicated as 1,2,3, ..22,X,Y,MT
Rscript get_ncbi37_transcription_coordinates.R results_file=temp.txt
# the below should return 13 
# (the header has only 12 values as a column heading for the first column
# (the row_id) is not included).
tail -n +2 temp.txt | awk -v OFS="\t" '{print NF}' | sort -u

# save the header in the 1st row of biomart output
head -n 1 temp.txt > ncbi37_biomart_transcript_cols_header.txt
# create file without header
tail -n +2 temp.txt > temp2.txt

# 2 based on the strand of the transcript, determine a TSS
# if the strand = 1, the TSS is the transcript_start, 
# if strand = -1 the TSS is the transcript_end
# also add the stand as either + or - as the 15th column
awk -v OFS="\t" '{if($7=="1")print $0,$3,"+"}' temp2.txt > ncbi37_biomart_transcript.txt
awk -v OFS="\t" '{if($7=="-1")print $0,$4,"-"}' temp2.txt >> ncbi37_biomart_transcript.txt

# 3 rearrange columns to form a proper bed file
awk -v OFS="\t" '{TNAME=$9" "$6; print $2,\
$14-1, \
$14, \
TNAME, \
1000, \
$15, \
$14-1, \
$14, \
"255,0,0", \
"1", \
"1", \
"0", \
"TSS", \
$0}' ncbi37_biomart_transcript.txt > ncbi37_biomart_transcript.bed

# 4 update genscan_mouse_genes_w_bed_cols_header.txt  to reflect all columns 
# in genscan_mouse_genes_w_bed_cols.bed
# add the standard UCSC col headers 1 to 12, the col 13 data set header to headers file
awk -v OFS="\t" '{print "chrom","chromStart","chromEnd","name","score","strand", \
"thickStart","thickEnd","itemRbg","blockCount","blockSizes","blockStarts", \
"data_source","row_id",$0,"TSS","strand2"}' ncbi37_biomart_transcript_cols_header.txt \
> ncbi37_biomart_transcript_BED_cols_header.txt

# remove temp files
rm temp.txt
rm temp2.txt


