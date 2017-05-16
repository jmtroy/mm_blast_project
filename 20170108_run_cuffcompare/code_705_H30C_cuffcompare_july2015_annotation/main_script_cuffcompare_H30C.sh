#!/bin/bash
#PBS -A simons
#PBS -l walltime=168:00:00
#PBS -l nodes=1:ppn=1
#PBS -N cuffcompare
#PBS -o cuffcompare.out
#PBS -e cuffcompare.err
#PBS -m abe
#PBS -M jmtroy2@igb.illinois.edu

# IMPORTANT: use the below qsub command to run from the projects code_060_edgeR_deg code directory
# qsub -v my_script_name=main_script_cuffcompare_H30C.sh -S /bin/bash main_script_cuffcompare_H30C.sh

#
#  This script...
#		runs cuffcompare on cuffcompare output from mouse Hypothalumus 30 minute controls
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

OUTPUT_DATA_FOLDER="$PROJECT_FOLDER"/output_705_H30C_cuffcompare_july2015_annotation"_"$RUN_ID
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

# merge A30C de novo cufflink gtf files into one merged.gtf file
module load samtools/0.1.19
module load cufflinks/2.2.1

#define 5 cufflinks gtf files
GTF1=/home/groups/simons/Joe/mouse_H_30/H_30_CK2_CGGCTATG-GGCTCTGA_L00M_R1_001.cufflinks_de_novo/transcripts.gtf
GTF2=/home/groups/simons/Joe/mouse_H_30/H_30_CK3_CGGCTATG-AGGCGAAG_L00M_R1_001.cufflinks_de_novo/transcripts.gtf
GTF3=/home/groups/simons/Joe/mouse_H_30/H_30_CK5_CGGCTATG-TAATCTTA_L00M_R1_001.cufflinks_de_novo/transcripts.gtf

# define the reference GTF (changed to use July 2015 annotation)
# REF_GTF="/home/groups/simons/Joe/ensembl37_NCBIM37_genome/genes.gtf" 
REF_GTF="/home/mirrors/igenome/Mus_musculus/NCBI/build37.2/Annotation/Archives/archive-2015-07-17-14-32-40/Genes/genes.gtf"


# point to folder with fastq for each chromosome
CHR_FA=/home/mirrors/igenome/Mus_musculus/NCBI/build37.2/Sequence/Chromosomes


# from ciffcompare document at http://cole-trapnell-lab.github.io/cufflinks/cuffcompare/index.html
#
# -o <outprefix>
# 
# All output files created by Cuffcompare will have this prefix
# (e.g. .loci, .tracking, etc.). If this option is not provided
# the default output prefix being used is: "cuffcmp"
# 
# -r
# 
# An optional “reference” annotation GFF file. Each sample is matched
# against this file, and sample isoforms are tagged as overlapping, matching, or novel
# where appropriate. See the refmap and tmap output file descriptions below.
# 
# -R
# 
# If -r was specified, this option causes cuffcompare to ignore reference
# transcripts that are not overlapped by any transcript in one of cuff1.gtf,…,cuffN.gtf.
# Useful for ignoring annotated transcripts that are not present in your RNA-Seq samples
# and thus adjusting the “sensitivity” calculation in the accuracy report
# written in the file
# 
# -s <seq_dir>
# 
# Causes cuffcompare to look into for fasta files with the underlying genomic
# sequences (one file per contig) against which your reads were aligned for
# some optional classification functions. For example, Cufflinks transcripts consisting
# mostly of lower-case bases are classified as repeats. Note that must contain
# one fasta file per reference chromosome, and each file must be named after
# the chromosome, and have a .fa or .fasta extension.
# 
# -C
# 
# Enables the “contained” transcripts to be also written in the .combined.gtffile,
# with the attribute "contained_in" showing the first container transfrag found. By
# default, without this option, cuffcompare does not write in that file isoforms that
# were found to be fully contained/covered (with the same compatible intron structure)
# by other transfrags in the same locus.
#
# -V
# 
# Cuffcompare is a little more verbose about what it’s doing, printing messages 
# to stderr, and it will also show warning messages about any inconsistencies 
# or potential issues found while reading the given GFF file(s).

cuffcompare -V -o "$OUTPUT_DATA_FOLDER"/contained -C -s "$CHR_FA" -r "$REF_GTF" -R "$GTF1" "$GTF2" "$GTF3" 2> "$OUTPUT_DATA_FOLDER"/contained.log.txt
 
# do not run this one # cuffcompare -V -o "$OUTPUT_DATA_FOLDER"/uncontained -s "$CHR_FA" -r "$REF_GTF" -R "$GTF1" "$GTF2" "$GTF3" "$GTF4" "$GTF5" 2> "$OUTPUT_DATA_FOLDER"/uncontained.log.txt
 
# copy the contents of the current folder (with this script and other code) to the saved code folder
cp -R "$CODE_FOLDER" "$SAVED_CODE"
echo end script "$my_script_name" at `date` >> "$RUN_LOG_FILE" 

