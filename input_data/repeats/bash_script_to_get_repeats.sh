#!/bin/bash

# 1 instructions to manually retrieve a repeats bed file from ucsc table browser

# OR use curl below ...

# 2 curl command to retrieve a repeats bed file from ucsc table browser

# 3 awk command to remove chr from chromosome names

# lets go........

# 1 
# manually download the mm9 repeatmasker from uscs using the table browser on 8/27/2016
# clade: mammal; genome: mouse; assembly: July 2007 (NCBI37/mm9);
# group: variation and repeats; track repeatMasker; 
# table: rmsk; region: genome; output format: BED
# output file: get_mm9_repeat_masker-20160827.bed ; 
# THEN ON SECOND PAGE:
# Create one BED per record: Whole Gene
# put file in /home/groups/simons/Joe/projects/20160818-compare-merged-gtf-A30cntrols/project_input_data/get_mm9_repeat_masker-20160827.bed

# 2 curl command to retrieve 
# the curl command was created using the firefox browser while retrieving the beb file
# per the manual instructions in step 1 above.
# In the browser menu select Tools / Web Developer / Web Console
# Then click the "get bed" on UCSC's table browser page, and save the file.
# Then to copy the CURL command, go to the "network" tab in the Web  Console window
# at the bottom of the screen.  In the first row in the tab (that has details of the GET to
# download the data) do a right-mouse click and choose 'copy as cURL'
# Finally you can paste the curl command into a script (as was done below)
original_repeats=get_mm9_repeat_masker-20170103.bed
curl 'http://genome.ucsc.edu/cgi-bin/hgTables?hgsid=573756641_7VjOqMgxjpj34b09qjaza1BvQQPu&boolshad.hgta_printCustomTrackHeaders=0&hgta_ctName=tb_rmsk&hgta_ctDesc=table+browser+query+on+rmsk&hgta_ctVis=pack&hgta_ctUrl=&fbQual=whole&fbUpBases=200&fbDownBases=200&hgta_doGetBed=get+BED' -H 'Host: genome.ucsc.edu' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:50.0) Gecko/20100101 Firefox/50.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: http://genome.ucsc.edu/cgi-bin/hgTables' -H 'Cookie: hguid=572584075_MeMKB1epJUTdvG5ZyVcqIjJoFluz; has_js=1; _ga=GA1.2.747086532.1483464066; _gat=1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' > $original_repeats

# 3 switch chromosome names
repeats_short_chrom_names=get_mm9_repeat_masker-20170103_short_chrom_names.bed

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
$1 == "chrY" {$1 = "Y"} ;1' $original_repeats > $repeats_short_chrom_names