#!/bin/bash
#PBS -A simons
#PBS -l walltime=168:00:00
#PBS -l nodes=1:ppn=1
#PBS -N gtf
#PBS -o gtf.out
#PBS -e gtf.err
#PBS -m abe
#PBS -M jmtroy2@igb.illinois.edu

# IMPORTANT: use the below qsub command to run from the projects code_060_edgeR_deg code directory
# qsub -v my_script_name=compare_gtf.sh -S /bin/bash compare_gtf.sh

#
#  This script...
#
# checks out the difference between a new gtf mm9 file (7/17/2015)
# and the old one used for simons (dated 3/18/2013)
#
# Also, we will see if any of the mouse BLAST results files have any hits with the new gtf
#

# change directory to torque working directory (the directory "qsub -S /bin/bash main_script.sh" was run from)
cd $PBS_O_WORKDIR

# set a variable with this scripts name
echo begin script "$my_script_name" at `date`

# Get project name, the project name is assumed to be same as the parent folder
# of the current folder.
# the current folder is assumed to be the code folder.
CURRENT_FOLDER=`pwd`
PARENT_FOLDER="$(dirname "$CURRENT_FOLDER")"
PROJECT_NAME="$(basename "$PARENT_FOLDER")"

# TO DO, set input_data_folder if needed
# input data folder not needed for main_script_edgeR_deg.sh script 
# INPUT_DATA_FOLDER=/home/a-m/jmtroy2/example_code_sets_for_stubbs_lab/2016_jun_wt_gso_rna_seq/aligned

# the PROJECT_FOLDER is in the simoms project foldes
PROJECT_FOLDER="$PARENT_FOLDER"
CODE_FOLDER="$CURRENT_FOLDER"
PROJECT_INPUT_DATA_FOLDER="$PROJECT_FOLDER"/project_input_data

## run id variable - output and intermediate files will go
## in the run id directory (for example /RUN_20130708_162650)
dt=`date +%Y%m%d`
tm=`date +%H%M%S`
RUN_ID=RUN_"$dt"_"$tm"

# TO DO, to help identify the contents of the outfolder, add something to the RUN_ID
RUN_ID="$RUN_ID"

## set a variable with the name of the directory the output (and interim data) will be placed, and then create the folders

# TO DO set the variable for the "interim data folder" if needed (remove the # at the beginning of line below)
# INTERIM_DATA_FOLDER="$PROJECT_FOLDER"/"$RUN_ID"/interim_data
# TO DO create the variable for the "interim data folder" if needed (remove the # at the beginning of line below)
# mkdir -p "$INTERIM_DATA_FOLDER" 

OUTPUT_DATA_FOLDER="$PROJECT_FOLDER"/output_compare_gtfs"_"$RUN_ID
SAVED_CODE="$OUTPUT_DATA_FOLDER"/saved_code
## (use -p option below) mkdir "$PROJECT_FOLDER"/"$RUN_ID"/output_data
mkdir -p "$OUTPUT_DATA_FOLDER" # the -p option will create any leading directories that do not already exist.
# no interim data folder for this project # mkdir -p "$INTERIM_DATA_FOLDER"

# create a run log file in the output folder
# This file can be used to capture any log information you need in your script.
RUN_LOG_FILE="$OUTPUT_DATA_FOLDER"/"$RUN_ID"_LOG.txt
echo begin script "$my_script_name" at `date` >> "$RUN_LOG_FILE" 
echo "The qsub job name: $PBS_JOBNAME" at `date` >> "$RUN_LOG_FILE"
echo "The qsub job id: $PBS_JOBID" at `date` >> "$RUN_LOG_FILE"
echo "The project folder is: $PROJECT_FOLDER" >> "$RUN_LOG_FILE"
echo "The code folder is: $CODE_FOLDER" >> "$RUN_LOG_FILE"

#################################################################################################
### BEGIN THE REAL WORK NOW THAT THE INITIAL HOUSE KEEPING IS DONE ##############################
#################################################################################################
module load bedops/2.4.2
module load bedtools/2.21.0


old_gtf=/home/groups/simons/Joe/ensembl37_NCBIM37_genome/genes.gtf

######################
# on 1/8/17 I changed to use file at /home/mirrors/igenome/Mus_musculus/NCBI/build37.2/Annotation/Archives/archive-2015-07-17-14-32-40/Genes/genes.gtf
# for the "new_gtf" file (as it was the same file I downloaded 12/5/16) md5sum for both files = 99a2a345b056b563ce6600c0d8741388 
#
# note the link download all the igenome data is below...
# ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/NCBI/build37.2/Mus_musculus_NCBI_build37.2.tar.gz
# #######################
# new_gtf=/home/a-m/jmtroy2/gtf/Mus_musculus/NCBI/build37.2/Annotation/Archives/archive-2015-07-17-14-32-40/Genes/genes.gtf
new_gtf=/home/mirrors/igenome/Mus_musculus/NCBI/build37.2/Annotation/Archives/archive-2015-07-17-14-32-40/Genes/genes.gtf


old_gtf_features="$OUTPUT_DATA_FOLDER"/old_gtf_features.txt
new_gtf_features="$OUTPUT_DATA_FOLDER"/new_gtf_features.txt

cut -f 3 $old_gtf | sort -u > $old_gtf_features
cut -f 3 $new_gtf | sort -u > $new_gtf_features

# convert .gtf files to bed so we can use bed tools
#	use bedops to convert the intergenic .gtf file to an intergenic .bed file

old_gtf_bed="$OUTPUT_DATA_FOLDER"/old_gtf.bed
new_gtf_bed="$OUTPUT_DATA_FOLDER"/new_gtf.bed
gtf2bed < $old_gtf > $old_gtf_bed
gtf2bed < $new_gtf > $new_gtf_bed

old_gtf_bed_exons_only="$OUTPUT_DATA_FOLDER"/old_gtf_exons_only.bed
new_gtf_bed_exons_only="$OUTPUT_DATA_FOLDER"/new_gtf_exons_only.bed

awk -F $'\t'  'BEGIN {OFS=FS} $8 == "exon" {print $0}' $old_gtf_bed > $old_gtf_bed_exons_only
awk -F $'\t'  'BEGIN {OFS=FS} $8 == "exon" {print $0}' $new_gtf_bed > $new_gtf_bed_exons_only

old_not_in_new="$OUTPUT_DATA_FOLDER"/old_not_in_new.bed
new_not_in_old="$OUTPUT_DATA_FOLDER"/new_not_in_old.bed

bedtools intersect -v -a $old_gtf_bed_exons_only -b $new_gtf_bed_exons_only > $old_not_in_new
bedtools intersect -v -a $new_gtf_bed_exons_only -b $old_gtf_bed_exons_only > $new_not_in_old

BED_FILE_A30C_E="/home/groups/simons/Joe/projects/20160906-run-mouse-A30-blast/output_716c_blast_intergenic_strict_filter_RUN_20161128_221658/intergenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed"
BED_FILE_A30C_I="/home/groups/simons/Joe/projects/20160906-run-mouse-A30-blast/output_717c_blast_intra_introns_strict_filter_RUN_20161129_121317/intragenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed"
BED_FILE_FC30C_E="/home/groups/simons/Joe/projects/20160908-mrsb-mm-FC30C-H30C-cuffcompare/output_816_blast_FC30C_intergenic_strict_filter_RUN_20161129_120212/intergenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed"
BED_FILE_FC30C_I="/home/groups/simons/Joe/projects/20160908-mrsb-mm-FC30C-H30C-cuffcompare/output_817_blast_FC30C_intragenic_strict_filter_RUN_20161129_120741/intragenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed"
BED_FILE_H30C_E="/home/groups/simons/Joe/projects/20160908-mrsb-mm-FC30C-H30C-cuffcompare/output_916_blast_H30C_intergenic_strict_filter_RUN_20161129_155118/intergenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed"
BED_FILE_H30C_I="/home/groups/simons/Joe/projects/20160908-mrsb-mm-FC30C-H30C-cuffcompare/output_917_blast_H30C_intragenic_strict_filter_RUN_20161129_155804/intragenic_transcripts_filtered_for_repeats_and_pseudo_genes.bed"

bedtools intersect -wo -a $BED_FILE_A30C_E -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_E_in_new.bed
bedtools intersect -wo -a $BED_FILE_A30C_I -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_I_in_new.bed
bedtools intersect -wo -a $BED_FILE_FC30C_E -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_E_in_new.bed
bedtools intersect -wo -a $BED_FILE_FC30C_I -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_I_in_new.bed
bedtools intersect -wo -a $BED_FILE_H30C_E -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_E_in_new.bed
bedtools intersect -wo -a $BED_FILE_H30C_I -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_I_in_new.bed

bedtools intersect -v -a $BED_FILE_A30C_E -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_E_NOT_in_new.bed
bedtools intersect -v -a $BED_FILE_A30C_I -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_I_NOT_in_new.bed
bedtools intersect -v -a $BED_FILE_FC30C_E -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_E_NOT_in_new.bed
bedtools intersect -v -a $BED_FILE_FC30C_I -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_I_NOT_in_new.bed
bedtools intersect -v -a $BED_FILE_H30C_E -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_E_NOT_in_new.bed
bedtools intersect -v -a $BED_FILE_H30C_I -b $new_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_I_NOT_in_new.bed

## now check transcripts intersecting with the old annotation.
## we do not expect much as cufflinks and cuffcompare should not have
## labeled the transcripts as intragenic or intergenic if they were found in the annotation (intersected with an exon)
 
bedtools intersect -wo -a $BED_FILE_A30C_E -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_E_in_old.bed
bedtools intersect -wo -a $BED_FILE_A30C_I -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_I_in_old.bed
bedtools intersect -wo -a $BED_FILE_FC30C_E -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_E_in_old.bed
bedtools intersect -wo -a $BED_FILE_FC30C_I -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_I_in_old.bed
bedtools intersect -wo -a $BED_FILE_H30C_E -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_E_in_old.bed
bedtools intersect -wo -a $BED_FILE_H30C_I -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_I_in_old.bed

bedtools intersect -v -a $BED_FILE_A30C_E -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_E_NOT_in_old.bed
bedtools intersect -v -a $BED_FILE_A30C_I -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/A30C_I_NOT_in_old.bed
bedtools intersect -v -a $BED_FILE_FC30C_E -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_E_NOT_in_old.bed
bedtools intersect -v -a $BED_FILE_FC30C_I -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/FC30C_I_NOT_in_old.bed
bedtools intersect -v -a $BED_FILE_H30C_E -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_E_NOT_in_old.bed
bedtools intersect -v -a $BED_FILE_H30C_I -b $old_gtf_bed_exons_only > "$OUTPUT_DATA_FOLDER"/H30C_I_NOT_in_old.bed

#####################################################################################
### END OF THE REAL WORK - DO the FINAL HOUSE KEEPING  ##############################
#####################################################################################

# copy the contents of the current folder (with this script and other code) to the saved code folder
cp -R "$CODE_FOLDER" "$SAVED_CODE"
echo end script "$my_script_name" at `date` >> "$RUN_LOG_FILE" 




