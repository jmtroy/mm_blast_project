#!/bin/bash
#PBS -A simons
#PBS -l walltime=168:00:00
#PBS -l nodes=1:ppn=1
#PBS -N untar
#PBS -o untar.out
#PBS -e untar.err
#PBS -m abe
#PBS -M jmtroy2@igb.illinois.edu

# change directory to torque working directory (the directory "qsub -S /bin/bash untar_accepted_hits_bam.sh" was run from)
cd $PBS_O_WORKDIR

##tar -zxvf mouse_A_30.tgz --absolute-names --wildcards --no-anchored 'accepted_hits.bam'

tar -zxvf mouse_FC_30.tgz --absolute-names --wildcards --no-anchored 'accepted_hits.bam'

tar -zxvf mouse_H_30.tgz --absolute-names --wildcards --no-anchored 'accepted_hits.bam'