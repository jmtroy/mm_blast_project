read me - Joe Troy 9/1/2016

commands to get files...

wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.1.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.2.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.3.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.4.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.5.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.6.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.7.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.8.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.9.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.10.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.11.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.12.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.13.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.14.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.15.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.16.protein.faa.gz

commands to cat files

cat human.1.protein.faa > human.protein.cat.file.faa
cat human.2.protein.faa >> human.protein.cat.file.faa
cat human.3.protein.faa >> human.protein.cat.file.faa
cat human.4.protein.faa >> human.protein.cat.file.faa
cat human.5.protein.faa >> human.protein.cat.file.faa
cat human.6.protein.faa >> human.protein.cat.file.faa
cat human.7.protein.faa >> human.protein.cat.file.faa
cat human.8.protein.faa >> human.protein.cat.file.faa
cat human.9.protein.faa >> human.protein.cat.file.faa
cat human.10.protein.faa >> human.protein.cat.file.faa
cat human.11.protein.faa >> human.protein.cat.file.faa
cat human.12.protein.faa >> human.protein.cat.file.faa
cat human.13.protein.faa >> human.protein.cat.file.faa
cat human.14.protein.faa >> human.protein.cat.file.faa
cat human.15.protein.faa >> human.protein.cat.file.faa
cat human.16.protein.faa >> human.protein.cat.file.faa

And then below are the commands to create the blast database files

# make a blast DB of the protein sequences in the protein .faa file
module load blast+/2.3.0
FASTA_IN=/home/groups/simons/Joe/mm_blast_project/input_data/ftp_human_protein_faa_files_from_ncbi/human.protein.cat.file.faa
DB_OUT=/home/groups/simons/Joe/mm_blast_project/input_data/ftp_human_protein_faa_files_from_ncbi/human.protein.cat.file.db
makeblastdb -in $FASTA_IN -input_type fasta -dbtype prot -out $DB_OUT -taxid 9606 -parse_seqids

After the command is run the blast database files are...

human.protein.cat.file.db.phr
human.protein.cat.file.db.pin
human.protein.cat.file.db.pnd
human.protein.cat.file.db.pni
human.protein.cat.file.db.pog
human.protein.cat.file.db.psd
human.protein.cat.file.db.psi
human.protein.cat.file.db.psq



