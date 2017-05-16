#!/bin/bash

# 1 get mouse N-SCAN table (N-SCAN_mouse_genes.txt)
# 1 remove heading in row 1 from table and save it to N-SCAN_mouse_genes_w_bed_cols_header.txt 

# 2 get mouse genscan table as bed file (N-SCAN_mouse_genes.bed)

# 3 paste N-SCAN_mouse_genes.txt and N-SCAN_mouse_genes.bed to N-SCAN_mouse_genes_w_bed_cols.bed
# 3 check that past worked and send errors to N-SCAN_mouse_genes_w_bed_cols.error.bed

# 4 update N-SCAN_mouse_genes_w_bed_cols_header.txt  to reflect all columns in N-SCAN_mouse_genes_w_bed_cols.bed

# 5 get N-SCAN mouse exons as bed file as N-SCAN_mouse_exons.bed
# 5 create a head file for N-SCAN_mouse_exons.bed called N-SCAN_mouse_exons_bed_header.txt

# lets go........

# 1 get mouse genscan table (genscan_mouse_genes.txt)
# use curl command as revealed by firefox network function when downloading genscan genes as table into temp.txt
curl 'http://genome.ucsc.edu/cgi-bin/hgTables' -H 'Host: genome.ucsc.edu' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:50.0) Gecko/20100101 Firefox/50.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=568457507_LtAEGbQuGC7XGbzOS8qmRHZePpwa&clade=mammal&org=Mouse&db=mm9&hgta_group=genes&hgta_track=nscanGene&hgta_table=0&hgta_regionType=genome&position=chr12%3A57795963-57815592&hgta_outputType=primaryTable&hgta_outFileName=' -H 'Cookie: hguid=543009779_J2FuQaQZf0BLwK53bVCW5yAYn9rz; _ga=GA1.2.1285962574.1456960824; has_js=1; _gat=1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' --data 'hgsid=568457507_LtAEGbQuGC7XGbzOS8qmRHZePpwa&jsh_pageVertPos=0&clade=mammal&org=Mouse&db=mm9&hgta_group=genes&hgta_track=nscanGene&hgta_table=nscanGene&hgta_regionType=genome&position=chr12%3A57795963-57815592&hgta_outputType=primaryTable&boolshad.sendToGalaxy=0&boolshad.sendToGreat=0&boolshad.sendToGenomeSpace=0&hgta_outFileName=N-SCAN_mouse_genes.txt&hgta_compressType=none&hgta_doTopSubmit=get+output' > temp.txt
# save header 
head -n 1 temp.txt > N-SCAN_mouse_genes_w_bed_cols_header.txt
# create file without header
tail -n +2 temp.txt > N-SCAN_mouse_genes.txt

# 2 get mouse N-SCAN table as bed file (genscan_mouse_genes.bed)
curl 'http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=568457507_LtAEGbQuGC7XGbzOS8qmRHZePpwa&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_nscanGene&hgta_ctDesc=table+browser+query+on+nscanGene&hgta_ctVis=pack&hgta_ctUrl=&fbQual=whole&fbUpBases=200&fbExonBases=0&fbIntronBases=0&fbDownBases=200&hgta_doGetBed=get+BED' -H 'Host: genome.ucsc.edu' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:50.0) Gecko/20100101 Firefox/50.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://genome.ucsc.edu/cgi-bin/hgTables' -H 'Cookie: hguid=543009779_J2FuQaQZf0BLwK53bVCW5yAYn9rz; _ga=GA1.2.1285962574.1456960824; has_js=1; _gat=1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' > temp.txt
# add 13th column with value "N-SCAN_mouse_genes"
awk -v OFS="\t" '{print $0, "N-SCAN_mouse_genes"}' temp.txt > N-SCAN_mouse_genes.bed

# 3 paste genscan_mouse_genes.txt and genscan_mouse_genes.bed to genscan_mouse_genes_w_bed_cols.bed
paste N-SCAN_mouse_genes.bed N-SCAN_mouse_genes.txt > N-SCAN_mouse_genes_w_bed_cols.bed
# 3 check that past worked and send errors to genscan_mouse_genes_w_bed_cols.error.bed
awk -v OFS="\t" '{if($1!=$16)print $0,"chrom mismatch"}' N-SCAN_mouse_genes_w_bed_cols.bed > N-SCAN_mouse_genes_w_bed_cols.error.bed
awk -v OFS="\t" '{if($2!=$18)print $0,"start mismatch"}' N-SCAN_mouse_genes_w_bed_cols.bed > N-SCAN_mouse_genes_w_bed_cols.error.bed
awk -v OFS="\t" '{if($3!=$19)print $0,"start mismatch"}' N-SCAN_mouse_genes_w_bed_cols.bed > N-SCAN_mouse_genes_w_bed_cols.error.bed

# 4 update genscan_mouse_genes_w_bed_cols_header.txt  to reflect all columns in genscan_mouse_genes_w_bed_cols.bed
# add the standard UCSC col headers 1 to 12, the col 13 data set header to headers file
awk -v OFS="\t" '{print "chrom","chromStart","chromEnd","name","score","strand","thickStart","thickEnd","itemRbg","blockCount","blockSizes","blockStarts","data_source",$0}' N-SCAN_mouse_genes_w_bed_cols_header.txt > temp_header.txt
rm N-SCAN_mouse_genes_w_bed_cols_header.txt
mv temp_header.txt N-SCAN_mouse_genes_w_bed_cols_header.txt

# 5 get genscan mouse exons as bed file as genscan_mouse_exons.bed
curl 'http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=568457507_LtAEGbQuGC7XGbzOS8qmRHZePpwa&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_nscanGene&hgta_ctDesc=table+browser+query+on+nscanGene&hgta_ctVis=pack&hgta_ctUrl=&fbUpBases=200&fbQual=exon&fbExonBases=0&fbIntronBases=0&fbDownBases=200&hgta_doGetBed=get+BED' -H 'Host: genome.ucsc.edu' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:50.0) Gecko/20100101 Firefox/50.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://genome.ucsc.edu/cgi-bin/hgTables' -H 'Cookie: hguid=543009779_J2FuQaQZf0BLwK53bVCW5yAYn9rz; _ga=GA1.2.1285962574.1456960824; has_js=1; _gat=1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' > temp.txt
# add column to the end.
awk -v OFS="\t" '{print $0, "N-SCAN_mouse_exons"}' temp.txt > N-SCAN_mouse_exons.bed
# 5 create a head file for N-SCAN_mouse_exons.bed called N-SCAN_mouse_exons_bed_header.txt
echo -e "chrom\tchromStart\tchromEnd\tname\tscore\tstrand\tthickStart\thickEnd\titemRbg\tblockCount\tblockSizes\tblockStarts\tdata_source" > N-SCAN_mouse_exons_bed_cols_header.txt
# remove temp.txt file
rm temp.txt

# 6 make bed files with short chrom names

# below is a crazy awk command to remove 'chr' from select chromosomes names
awk -F $'\t'  'BEGIN {OFS=FS} $1 == "chr1" {$1 = "1"} \
$1 == "chr2" {$1 = "2"} \
$1 == "chr3" {$1 = "3"} \
$1 == "chr4" {$1 = "4"} \
$1 == "chr5" {$1 = "5"} \
$1 == "chr6" {$1 = "6"} \
$1 == "chr7" {$1 = "7"} \
$1 == "chr8" {$1 = "8"} \
$1 == "chr9" {$1 = "9"} \
$1 == "chr10" {$1 = "10"} \
$1 == "chr11" {$1 = "11"} \
$1 == "chr12" {$1 = "12"} \
$1 == "chr13" {$1 = "13"} \
$1 == "chr14" {$1 = "14"} \
$1 == "chr15" {$1 = "15"} \
$1 == "chr16" {$1 = "16"} \
$1 == "chr17" {$1 = "17"} \
$1 == "chr18" {$1 = "18"} \
$1 == "chr19" {$1 = "19"} \
$1 == "chr20" {$1 = "20"} \
$1 == "chr21" {$1 = "21"} \
$1 == "chr22" {$1 = "22"} \
$1 == "chrX" {$1 = "X"} \
$1 == "chrY" {$1 = "Y"} ;1' N-SCAN_mouse_genes_w_bed_cols.bed > N-SCAN_mouse_genes_w_bed_cols_w_short_chrom_names.bed

awk -F $'\t'  'BEGIN {OFS=FS} $1 == "chr1" {$1 = "1"} \
$1 == "chr2" {$1 = "2"} \
$1 == "chr3" {$1 = "3"} \
$1 == "chr4" {$1 = "4"} \
$1 == "chr5" {$1 = "5"} \
$1 == "chr6" {$1 = "6"} \
$1 == "chr7" {$1 = "7"} \
$1 == "chr8" {$1 = "8"} \
$1 == "chr9" {$1 = "9"} \
$1 == "chr10" {$1 = "10"} \
$1 == "chr11" {$1 = "11"} \
$1 == "chr12" {$1 = "12"} \
$1 == "chr13" {$1 = "13"} \
$1 == "chr14" {$1 = "14"} \
$1 == "chr15" {$1 = "15"} \
$1 == "chr16" {$1 = "16"} \
$1 == "chr17" {$1 = "17"} \
$1 == "chr18" {$1 = "18"} \
$1 == "chr19" {$1 = "19"} \
$1 == "chr20" {$1 = "20"} \
$1 == "chr21" {$1 = "21"} \
$1 == "chr22" {$1 = "22"} \
$1 == "chrX" {$1 = "X"} \
$1 == "chrY" {$1 = "Y"} ;1' N-SCAN_mouse_exons.bed > N-SCAN_mouse_exons_w_short_chrom_names.bed


# MORE notes on the curl commands above
#
# the curl commands above are were retrieved by accessing UCSC table browser in Firefox
# (see the UCSC table browser settings for each retrieval below)
# Then, right before retrieving the data, The "Tools / Web Developer / Network" menu item 
# is used in Firefox to capture the exact syntax of the http request used to download 
# the USCS table browser data.
# Right after the data is downloaded a right click in Firefox's network window on the entry
# representing the request for download will have a "Copy as cURL" menu item, that allows
# the request to be copied and pasted into this script (see the 3 curl commands above).
#
# In Addition, below are the UCSC table browser settings used to retrieve the data.
# note: if you use the curl commands above, or download the data with the below settings
# you will get identical data files.
#
# UCSC table browser settings are below if one were to retrieve the data manually
# and not use the curl commands above. 
#
# 1 get mouse genscan table (genscan_mouse_genes.txt)
# clade: Mammal 
# genome: Mouse
# assembly: July 2007 (NCBI37/mm9)
# group: Genes and Gene Predictions
# track: N-SCAN
# table: nscanGene
# region: genome
# output format: all fields from selected table
# output file: N-SCAN_mouse_genes.txt
# then press "get output"
#
#
# 2 get mouse genscan table as bed file (genscan_mouse_genes.bed)
# clade: Mammal 
# genome: Mouse
# assembly: July 2007 (NCBI37/mm9)
# group: Genes and Gene Predictions
# track: Genscan Genes
# table: genscan
# region: genome
# output format: BED browser extensible data 
# output file: N-SCAN_mouse_genes.bed
# then press "get output"
# Create one BED record per: Whole Gene
#
#
# 5 get genscan mouse exons as bed file as genscan_mouse_exons.bed
# clade: Mammal 
# genome: Mouse
# assembly: July 2007 (NCBI37/mm9)
# group: Genes and Gene Predictions
# track: Genscan Genes
# table: genscan
# region: genome
# output format: BED browser extensible data 
# output file: N-SCAN__mouse_exons.bed
# then press "get output"
# Create one BED record per: Exon
#
