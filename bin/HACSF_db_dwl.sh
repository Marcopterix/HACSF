#!/usr/bin/env bash

#----------------------------
# Database download for HACF
#----------------------------

echo -e "\n""\033[42m================================================\033[m"
echo -e "\033[42m========== Starting database download ==========\033[m"
echo -e "\033[42m================================================\033[m""\n"

echo -e "\033[4;33m========== Creating database in $HOME/db/BLASTx/HA ==========\033[0m\n"

mkdir -p $HOME/db/BLASTx/HA
cd $HOME/db/BLASTx/HA

#------------
# HA protein
#------------

esearch -db protein -query "Influenza A virus [Organism] AND (H5N* [All Fields] OR H7N* [All Fields]) AND hemagglutinin [Protein Name] " \
        | efetch -format fasta > HA_IA.faa

seqkit seq -g -m 564 -M 564 HA_IA.faa > HA_IA.fa

echo -e "\033[0;36m========== HA gene database created ==========\033[0m\n"


rm ./*.faa

#------------------------------
# Creating database with BLAST
#------------------------------

makeblastdb -in HA_IA.fa -dbtype prot -out ./IA_H_prot

echo -e "\033[46m========== database created ==========\033[m"
