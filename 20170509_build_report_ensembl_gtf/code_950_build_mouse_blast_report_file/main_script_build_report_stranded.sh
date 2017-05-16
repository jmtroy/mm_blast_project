#!/bin/bash
#PBS -A simons
#PBS -l walltime=168:00:00
#PBS -l nodes=1:ppn=1
#PBS -N report
#PBS -o report.out
#PBS -e report.err
#PBS -m abe
#PBS -M jmtroy2@igb.illinois.edu

# IMPORTANT: use the below qsub command to run from the projects code folder
# qsub -v my_script_name=main_script_build_report_stranded.sh -S /bin/bash main_script_build_report_stranded.sh

#
#  This script...
#
#	Gets BLASTX results of mouse un-annotated expression to human protein
#	Gets TSS data from ensemble, and genscan and N-SCAN data from UCSC
#
#	Converts above data sets to bed format and creates report files.
#
#

# change directory to torque working directory (the directory the script was run from)
cd $PBS_O_WORKDIR

# echo out script name and time
echo begin script "$my_script_name" at `date`

# Get project name, the project name is assumed to be same as the parent folder
# of the current folder.
# the current folder is assumed to be the code folder.
CURRENT_FOLDER=`pwd`
PARENT_FOLDER="$(dirname "$CURRENT_FOLDER")"
PROJECT_NAME="$(basename "$PARENT_FOLDER")"

# TO DO, set input_data_folder if needed
INPUT_DATA_FOLDER="/home/groups/simons/Joe/mm_blast_project/input_data"

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

OUTPUT_DATA_FOLDER="$PROJECT_FOLDER"/output_950_build_mouse_blast_report_file"_"$RUN_ID
SAVED_CODE="$OUTPUT_DATA_FOLDER"/saved_code
## (use -p option below) mkdir "$PROJECT_FOLDER"/"$RUN_ID"/output_data
mkdir -p "$OUTPUT_DATA_FOLDER" # the -p option will create any leading directories that do not already exist.
INTERIM_DATA_FOLDER="$OUTPUT_DATA_FOLDER"/interim_data
# not needed for this script # mkdir -p "$INTERIM_DATA_FOLDER"

# create a run log file in the output folder
# This file can be used to capture any log information you need in your script.
RUN_LOG_FILE="$OUTPUT_DATA_FOLDER"/"$RUN_ID"_LOG.txt
echo begin script "$my_script_name" at `date` >> "$RUN_LOG_FILE" 
echo "The qsub job name: $PBS_JOBNAME" at `date` >> "$RUN_LOG_FILE"
echo "The qsub job id: $PBS_JOBID" at `date` >> "$RUN_LOG_FILE"
echo "The project folder is: $PROJECT_FOLDER" >> "$RUN_LOG_FILE"
echo "The code folder is: $CODE_FOLDER" >> "$RUN_LOG_FILE"
echo "The output folder is: $OUTPUT_DATA_FOLDER" >> "$RUN_LOG_FILE"

#################################################################################################
### BEGIN THE REAL WORK NOW THAT THE INITIAL HOUSE KEEPING IS DONE ##############################
#################################################################################################



# new output folders as on 1/17/2017
# output_A30C_intERgenic_blastx_RUN_20170117_203327
# output_A30C_intRAgenic_blastx_RUN_20170117_203353
# output_FC30C_intERgenic_blastx_RUN_20170117_203417
# output_FC30C_intRAgenic_blastx_RUN_20170117_203503
# output_H30C_intERgenic_blastx_RUN_20170117_203532
# output_H30C_intRAgenic_blastx_RUN_20170117_203612

# get the BLAST results from a previous project
BLAST_FILE_A30C_E="/home/groups/simons/Joe/mm_blast_project/20170509_blastx_ensembl_gtf/output_blastx_RUN_20170509_130943/A30C_intERgenic/blast_results_fmt6_ftp_db.txt"
BLAST_FILE_A30C_I="/home/groups/simons/Joe/mm_blast_project/20170509_blastx_ensembl_gtf/output_blastx_RUN_20170509_130943/A30C_intRAgenic/blast_results_fmt6_ftp_db.txt"
BLAST_FILE_FC30C_E="/home/groups/simons/Joe/mm_blast_project/20170509_blastx_ensembl_gtf/output_blastx_RUN_20170509_130943/FC30C_intERgenic/blast_results_fmt6_ftp_db.txt"
BLAST_FILE_FC30C_I="/home/groups/simons/Joe/mm_blast_project/20170509_blastx_ensembl_gtf/output_blastx_RUN_20170509_130943/FC30C_intRAgenic/blast_results_fmt6_ftp_db.txt"
BLAST_FILE_H30C_E="/home/groups/simons/Joe/mm_blast_project/20170509_blastx_ensembl_gtf/output_blastx_RUN_20170509_130943/H30C_intERgenic/blast_results_fmt6_ftp_db.txt"
BLAST_FILE_H30C_I="/home/groups/simons/Joe/mm_blast_project/20170509_blastx_ensembl_gtf/output_blastx_RUN_20170509_130943/H30C_intRAgenic/blast_results_fmt6_ftp_db.txt"

AVG_RPKM_FILE_A30C="$PROJECT_INPUT_DATA_FOLDER"/RPKMS/output/A30C_rpkm_counts.bed
AVG_RPKM_FILE_FC30C="$PROJECT_INPUT_DATA_FOLDER"/RPKMS/output/FC30C_rpkm_counts.bed
AVG_RPKM_FILE_H30C="$PROJECT_INPUT_DATA_FOLDER"/RPKMS/output/H30C_rpkm_counts.bed

# create variables for the POS ANNOtation and PEAK files created by Chris Seward
# annotation
A_H3K4ME3_POS_ANNO=/home/groups/simons/Joe/mm_blast_project/input_data/mm_histone_mark_data/anno/AMY-H3k4me3_F3L0_200_peaks-anno.pos
FC_H3K4ME3_POS_ANNO=/home/groups/simons/Joe/mm_blast_project/input_data/mm_histone_mark_data/anno/FCX-H3k4me3_F3L0_200_peaks-anno.pos
H_H3K4ME3_POS_ANNO=/home/groups/simons/Joe/mm_blast_project/input_data/mm_histone_mark_data/anno/HYP-H3k4me3_F3L0_200_peaks-anno.pos
# peaks
A_H3K4ME3_POS_PEAK=/home/groups/simons/Joe/mm_blast_project/input_data/mm_histone_mark_data/peaks/mouse/AMY-H3k4me3_F3L0_200_peaks.pos
FC_H3K4ME3_POS_PEAK=/home/groups/simons/Joe/mm_blast_project/input_data/mm_histone_mark_data/peaks/mouse/FCX-H3k4me3_F3L0_200_peaks.pos
H_H3K4ME3_POS_PEAK=/home/groups/simons/Joe/mm_blast_project/input_data/mm_histone_mark_data/peaks/mouse/HYP-H3k4me3_F3L0_200_peaks.pos
# create names for the new combined annotation and peaks files
A_H3K4ME3_DATA="$OUTPUT_DATA_FOLDER"/A_h3k4me3_data.bed
FC_H3K4ME3_DATA="$OUTPUT_DATA_FOLDER"/FC_h3k4me3_data.bed
H_H3K4ME3_DATA="$OUTPUT_DATA_FOLDER"/H_h3k4me3_data.bed
# call scripts to populate new ew combined annotation and peaks files
sh merge_anno_peak_pos_files.sh $A_H3K4ME3_POS_ANNO $A_H3K4ME3_POS_PEAK $A_H3K4ME3_DATA $OUTPUT_DATA_FOLDER
sh merge_anno_peak_pos_files.sh $FC_H3K4ME3_POS_ANNO $FC_H3K4ME3_POS_PEAK $FC_H3K4ME3_DATA $OUTPUT_DATA_FOLDER
sh merge_anno_peak_pos_files.sh $H_H3K4ME3_POS_ANNO $H_H3K4ME3_POS_PEAK $H_H3K4ME3_DATA $OUTPUT_DATA_FOLDER


BLAST_RESULTS_FILE="$BLAST_FILE_A30C_E"
DATA_SET_NAME="A30_intERgenic_Exons"
AVG_RPKM="$AVG_RPKM_FILE_A30C"
sh build_individual_report_genscan_nscan_exons.sh "$OUTPUT_DATA_FOLDER" "$INPUT_DATA_FOLDER" "$BLAST_RESULTS_FILE" "$DATA_SET_NAME" "$AVG_RPKM" "$A_H3K4ME3_DATA"

BLAST_RESULTS_FILE="$BLAST_FILE_A30C_I"
DATA_SET_NAME="A30_intRAgenic_Exons"
AVG_RPKM="$AVG_RPKM_FILE_A30C"
sh build_individual_report_genscan_nscan_exons.sh "$OUTPUT_DATA_FOLDER" "$INPUT_DATA_FOLDER" "$BLAST_RESULTS_FILE" "$DATA_SET_NAME" "$AVG_RPKM" "$A_H3K4ME3_DATA"

BLAST_RESULTS_FILE="$BLAST_FILE_FC30C_E"
DATA_SET_NAME="FC30_intERgenic_Exons"
AVG_RPKM="$AVG_RPKM_FILE_FC30C"
sh build_individual_report_genscan_nscan_exons.sh "$OUTPUT_DATA_FOLDER" "$INPUT_DATA_FOLDER" "$BLAST_RESULTS_FILE" "$DATA_SET_NAME" "$AVG_RPKM" "$FC_H3K4ME3_DATA"

BLAST_RESULTS_FILE="$BLAST_FILE_FC30C_I"
DATA_SET_NAME="FC30_intRAgenic_Exons"
AVG_RPKM="$AVG_RPKM_FILE_FC30C"
sh build_individual_report_genscan_nscan_exons.sh "$OUTPUT_DATA_FOLDER" "$INPUT_DATA_FOLDER" "$BLAST_RESULTS_FILE" "$DATA_SET_NAME" "$AVG_RPKM" "$FC_H3K4ME3_DATA"

BLAST_RESULTS_FILE="$BLAST_FILE_H30C_E"
DATA_SET_NAME="H30_intERgenic_Exons"
AVG_RPKM="$AVG_RPKM_FILE_H30C"
sh build_individual_report_genscan_nscan_exons.sh "$OUTPUT_DATA_FOLDER" "$INPUT_DATA_FOLDER" "$BLAST_RESULTS_FILE" "$DATA_SET_NAME" "$AVG_RPKM" "$H_H3K4ME3_DATA"

BLAST_RESULTS_FILE="$BLAST_FILE_H30C_I"
DATA_SET_NAME="H30_intRAgenic_Exons"
AVG_RPKM="$AVG_RPKM_FILE_H30C"
sh build_individual_report_genscan_nscan_exons.sh "$OUTPUT_DATA_FOLDER" "$INPUT_DATA_FOLDER" "$BLAST_RESULTS_FILE" "$DATA_SET_NAME" "$AVG_RPKM" "$H_H3K4ME3_DATA"

#
# We want to check how our all data set report compares to the NCBI 37.2 gtf file we used
# remember: we are looking trying to analyze exons that do not have annotation
#
ALL_DATA_SET_REPORT="$OUTPUT_DATA_FOLDER"/all_data_set_report.txt
# (DO NOT THE 2015 ANNOTATION FILE - use ensembl GTF instead)
# GENES_GTF=/home/mirrors/igenome/Mus_musculus/NCBI/build37.2/Annotation/Archives/archive-2015-07-17-14-32-40/Genes/genes.gtf
GENES_GTF=/home/groups/simons/Joe/ensembl37_NCBIM37_genome/genes.gtf
#	use bedops to convert the genes.gtf file to an genes.bed file
module load bedops/2.4.2
GENES_BED="$OUTPUT_DATA_FOLDER"/genes.bed
gtf2bed < $GENES_GTF > $GENES_BED
# now do a bedtools intersect to see what the all data set report and the annotation
# have in common
module load bedtools/2.21.0
GENES_SORTED_BED="$OUTPUT_DATA_FOLDER"/genes_sorted.bed
bedtools sort -i $GENES_BED > $GENES_SORTED_BED
ALL_DATA_SET_BED="$OUTPUT_DATA_FOLDER"/all_data_set_report.bed
tail -n +2 $ALL_DATA_SET_REPORT > $ALL_DATA_SET_BED
BLAST_RESULTS_VS_ANNOTATION="$OUTPUT_DATA_FOLDER"/blast_results_vs_annotation.txt
# bedtools intersect
# option -s = force strandedness
# optipn -wo = Write the original A and B entries plus the number of base pairs of overlap between the two features. Only A features with overlap are reported. 
bedtools intersect -wo -a $ALL_DATA_SET_BED -b $GENES_SORTED_BED -s > $BLAST_RESULTS_VS_ANNOTATION 2>bedtools_annotation_check_error.txt

#####################################################################################
### END OF THE REAL WORK - DO the FINAL HOUSE KEEPING  ##############################
#####################################################################################

# copy the contents of the current folder (with this script and other code) to the saved code folder
cp -R "$CODE_FOLDER" "$SAVED_CODE"
echo end script "$my_script_name" at `date` >> "$RUN_LOG_FILE" 

