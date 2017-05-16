#!/bin/bash
#PBS -A simons
#PBS -l walltime=168:00:00
#PBS -l nodes=1:ppn=8
#PBS -N report
#PBS -o report.out
#PBS -e report.err
#PBS -m abe
#PBS -M jmtroy2@igb.illinois.edu

# IMPORTANT: use the below qsub command to run from the projects code folder
# qsub -v my_script_name=main_cufflinks_cuffcompare.sh -S /bin/bash main_cufflinks_cuffcompare.sh

# pool mouse bam files together and then run cufflinks

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

OUTPUT_DATA_FOLDER="$PROJECT_FOLDER"/output_code_pooled_cufflinks_denovo_cuffcompare_w_ensembl_gtf"_"$RUN_ID
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

# load software modules
module load samtools/0.1.19
module load cufflinks/2.2.1

A30C_merged_BAM=/home/groups/simons/Joe/mm_blast_project/20170411_cufflinks_pooled/output_950_build_mouse_blast_report_file_RUN_20170411_114340/A30C_merged_accepted_hits.bam
FC30C_merged_BAM=/home/groups/simons/Joe/rabt_blast_project_mm/20170508_pooled_cufflinks_rabt/output_pooled_cufflinks_rabt_RUN_20170509_100600/FC30C_merged_accepted_hits.bam
H30C_merged_BAM=/home/groups/simons/Joe/rabt_blast_project_mm/20170508_pooled_cufflinks_rabt/output_pooled_cufflinks_rabt_RUN_20170509_100600/H30C_merged_accepted_hits.bam

A30C_OUT_FLD="$OUTPUT_DATA_FOLDER"/A30C_pooled_cufflinks_de_novo
cufflinks -p 8 -o "$A30C_OUT_FLD" "$A30C_merged_BAM"

FC30C_OUT_FLD="$OUTPUT_DATA_FOLDER"/FC30C_pooled_cufflinks_de_novo
cufflinks -p 8 -o "$FC30C_OUT_FLD" "$FC30C_merged_BAM"

H30C_OUT_FLD="$OUTPUT_DATA_FOLDER"/H30C_pooled_cufflinks_de_novo
cufflinks -p 8 -o "$H30C_OUT_FLD" "$H30C_merged_BAM"

# point to gtf and folder with fastq for each chromosome
gtf=/home/groups/simons/Joe/ensembl37_NCBIM37_genome/genes.gtf
CHR_FA=/home/mirrors/igenome/Mus_musculus/NCBI/build37.2/Sequence/Chromosomes

# do cuffcompare (see notes below)
GTF1="$A30C_OUT_FLD"/transcripts.gtf
mkdir "$OUTPUT_DATA_FOLDER"/A30C_cuffcompare
CUFFCOMPARE_OUT="$OUTPUT_DATA_FOLDER"/A30C_cuffcompare/contained
cuffcompare -V -o "$CUFFCOMPARE_OUT" -C -s "$CHR_FA" -r "$gtf" -R "$GTF1" 2> "$OUTPUT_DATA_FOLDER"/A30C_contained.log.txt

GTF1="$FC30C_OUT_FLD"/transcripts.gtf
mkdir "$OUTPUT_DATA_FOLDER"/FC30C_cuffcompare
CUFFCOMPARE_OUT="$OUTPUT_DATA_FOLDER"/FC30C_cuffcompare/contained
cuffcompare -V -o "$CUFFCOMPARE_OUT" -C -s "$CHR_FA" -r "$gtf" -R "$GTF1" 2> "$OUTPUT_DATA_FOLDER"/FC30C_contained.log.txt

GTF1="$H30C_OUT_FLD"/transcripts.gtf
mkdir "$OUTPUT_DATA_FOLDER"/H30C_cuffcompare
CUFFCOMPARE_OUT="$OUTPUT_DATA_FOLDER"/H30C_cuffcompare/contained
cuffcompare -V -o "$CUFFCOMPARE_OUT" -C -s "$CHR_FA" -r "$gtf" -R "$GTF1" 2> "$OUTPUT_DATA_FOLDER"/H30C_contained.log.txt

#####################################################################################
### END OF THE REAL WORK - DO the FINAL HOUSE KEEPING  ##############################
#####################################################################################

# copy the contents of the current folder (with this script and other code) to the saved code folder
cp -R "$CODE_FOLDER" "$SAVED_CODE"
echo end script "$my_script_name" at `date` >> "$RUN_LOG_FILE" 
