# 2014-10-30
# Joe Troy 
# jmtroy2 [at] illinois.edu

# Acknowlegement: Thanks to Michael Saul for his biomaRt script, which comprises most of the
# code for this script

#usage:
#Rscript get_ncbi37_transcription_coordinates.R results_file=ncbi37_biomart.txt

# process command lines
args <- commandArgs(trailingOnly = TRUE)
# set argument defaults
results_file = "ncbi37_biomart.txt"  #  ncbi37_biomart.txt is the default

# loop through arguments and assign values
arg_count <- length(args)
print("start loop")
for ( xxx in seq(along=args)) {
	# print(paste("xxx = ",xxx))
	re = regexpr("=",args[xxx],fixed=TRUE)
	argname = substr(args[xxx],1,re[1]-1)
	# print(paste("argname =",argname,sep=""))
	argvalue = substr(args[xxx],re[1]+1,nchar(args[xxx]))
	# print(paste("argvalue =",argvalue,sep=""))	
	
	if (argname == 'results_file') {
		results_file = argvalue
	} 
	}
## print("end loop")

# the below code is commented out, but run it if needed to install the biomaRt package 
# code CHUNK 1 - install biomaRt R package if you haven't already
#source("http://bioconductor.org/biocLite.R")
#biocLite("biomaRt")

# code CHUNK 2 - load the library
library(biomaRt)

# code CHUNK 3 - retreive select protein family data
# Setting biomaRt to create annotations - use an archive w NCBI37data
ensembl=useMart(host='may2012.archive.ensembl.org', biomart='ENSEMBL_MART_ENSEMBL',dataset = "mmusculus_gene_ensembl")

## create a vector of attributes you want in the results
my_attributes = c("chromosome_name","transcript_start","transcript_end","ensembl_gene_id","ensembl_transcript_id","strand","external_gene_id","external_transcript_id","transcript_biotype","source","status","transcript_status")
## perform a query and put results into a data frame
biomart_results_df = getBM(mart = ensembl,attributes = my_attributes,uniqueRows = TRUE )

# code CHUNK 4 - write the query results to a file.

write.table(biomart_results_df,file=results_file,sep="\t",row.names = TRUE,col.names = TRUE,quote = FALSE)
