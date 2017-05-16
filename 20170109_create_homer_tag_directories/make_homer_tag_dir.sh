#!/bin/bash
#PBS -A simons
#PBS -l walltime=168:00:00
#PBS -l nodes=1:ppn=1
#PBS -N homer_tags
#PBS -o homer_tags.out
#PBS -e homer_tags.err
#PBS -m abe
#PBS -M jmtroy2@igb.illinois.edu

#
#  NOTE: after creating, the tag directories are move to stubbslab @ /home/jmtroy2/jmt/projects/20161207-temp-mrsb-homer-tag-dirs
#  and then deleted from biocluster
#
#


# change directory to torque working directory (the directory "qsub -S /bin/bash make_homer_tag_dir.sh" was run from)
cd $PBS_O_WORKDIR

# load homer - doh!
module load HOMER/4.7.2
HOMERBIN="/home/apps/HOMER/HOMER-4.7.2/bin"

# output folder is mouse_A_30_tags/
# format is set to sam [-format sam] which is used to read bam files (or sam files)
# -unique only count uniquely alignable reads 

A1=./mouse_A_30/A_30_CK1_ATTACTCG-TAATCTTA_L00M_R1_001.tophat/accepted_hits.bam
A2=./mouse_A_30/A_30_CK2_ATTACTCG-CAGGACGT_L00M_R1_001.tophat/accepted_hits.bam
A3=./mouse_A_30/A_30_CK3_ATTACTCG-GTACTGAC_L00M_R1_001.tophat/accepted_hits.bam
A4=./mouse_A_30/A_30_CK4_TCCGGAGA-TATAGCCT_L00M_R1_001.tophat/accepted_hits.bam
A5=./mouse_A_30/A_30_CK5_TCCGGAGA-ATAGAGGC_L00M_R1_001.tophat/accepted_hits.bam

# "$HOMERBIN"/makeTagDirectory mouse_A_30_tags/ -unique -format sam $A1 $A2  $A3  $A4  $A5
# (already ran on 12/8/16 - no need to run again)
#"$HOMERBIN"/makeTagDirectory mmA30C1_tags/ -unique -format sam $A1 
#"$HOMERBIN"/makeTagDirectory mmA30C2_tags/ -unique -format sam $A2
#"$HOMERBIN"/makeTagDirectory mmA30C3_tags/ -unique -format sam $A3
#"$HOMERBIN"/makeTagDirectory mmA30C4_tags/ -unique -format sam $A4
#"$HOMERBIN"/makeTagDirectory mmA30C5_tags/ -unique -format sam $A5

FC1=./mouse_FC_30/FC_30_CK1_ATTCAGAA-GGCTCTGA_L00M_R1_001.tophat/accepted_hits.bam
FC2=./mouse_FC_30/FC_30_CK2_ATTCAGAA-AGGCGAAG_L00M_R1_001.tophat/accepted_hits.bam
FC3=./mouse_FC_30/FC_30_CK3_ATTCAGAA-TAATCTTA_L00M_R1_001.tophat/accepted_hits.bam
FC4=./mouse_FC_30/FC_30_CK4_ATTCAGAA-CAGGACGT_L00M_R1_001.tophat/accepted_hits.bam
FC5=./mouse_FC_30/FC_30_CK5_ATTCAGAA-GTACTGAC_L00M_R1_001.tophat/accepted_hits.bam

"$HOMERBIN"/makeTagDirectory mmFC30C1_tags/ -unique -format sam $FC1 
"$HOMERBIN"/makeTagDirectory mmFC30C2_tags/ -unique -format sam $FC2
"$HOMERBIN"/makeTagDirectory mmFC30C3_tags/ -unique -format sam $FC3
"$HOMERBIN"/makeTagDirectory mmFC30C4_tags/ -unique -format sam $FC4
"$HOMERBIN"/makeTagDirectory mmFC30C5_tags/ -unique -format sam $FC5

H2=./mouse_H_30/H_30_CK2_CGGCTATG-GGCTCTGA_L00M_R1_001.tophat/accepted_hits.bam
H3=./mouse_H_30/H_30_CK3_CGGCTATG-AGGCGAAG_L00M_R1_001.tophat/accepted_hits.bam
H5=./mouse_H_30/H_30_CK5_CGGCTATG-TAATCTTA_L00M_R1_001.tophat/accepted_hits.bam

"$HOMERBIN"/makeTagDirectory mmH30C2_tags/ -unique -format sam $H2
"$HOMERBIN"/makeTagDirectory mmH30C3_tags/ -unique -format sam $H3
"$HOMERBIN"/makeTagDirectory mmH30C5_tags/ -unique -format sam $H5


