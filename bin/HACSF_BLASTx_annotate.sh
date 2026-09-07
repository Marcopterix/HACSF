#!/usr/bin/env bash

echo -e "\n""\033[42m#########################################\033[m"
echo -e "\033[42m=============== Annotating ==============\033[m"
echo -e "\033[42m====== $(date) =====\033[m"
echo -e "\033[42m#########################################\033[m" "\n"

#---------
# Options
#---------

usage () {
echo ""
echo -e "\033[4;33m===== Bash script designed to extract amino acid sequences of the segment 4 (HA) gene of IA virus and predict pathogenicity. =====\033[0m"
echo ""
echo "Pipeline developed in the Massive Sequencing and Bioinformatics area of CENASA, SENASICA."
echo ""
echo -e "\033[4;33mThis is the first step: Annotation with BLASTx and obtaining amino acid sequences.\033[0m"
echo ""
echo "Options:"
echo "Usage: $0 -f FASTA file PATH -o OUTDIR PATH -p BLAST DB PATH"
echo " -h print help "
echo " -f FASTA file directory "
echo " -o OUTPUT directory "
echo " -p PATH to BLAST database. If you downloaded the database by running the HACF_db_dwl.sh script, the path to your database is: $HOME/db/BLASTx/HA "
echo "";
        }

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

while getopts ":hf:o:p:" opt; do
     case ${opt} in
h)
  usage; exit
;;
f)
  dirfa=${OPTARG}
;;
o)
  dirout=${OPTARG}
;;
p)
  dirdb=${OPTARG}
;;
:)
  echo -e "\033[0;33mOption -${OPTARG} requires an argument.\033[0m"
exit
;;
\?)
  echo -e "\033[0;31mInvalid option -${OPTARG}.\033[0m"
exit 1
;;
     esac
  done

#
 if [[ ${dirfa} == ${dirout} ]]; then
     echo -e "\033[0;31mError: -f and -o cannot be the same PATH.\033[0m"
     exit 1
fi

#

if [[ -z ${dirfa} ]]; then
    echo -e "\033[0;33mError: Option -f is necesary.\033[0m"
    exit 1
fi

if [[ -z ${dirout} ]]; then
    echo -e "\033[0;33mError: Option -o is necesary.\033[0m"
    exit 1
fi

if [[ -z ${dirdb} ]]; then
    echo -e "\033[0;33mError: Option -p is necesary.\033[0m"
    echo -e "\033[0;33mIf you downloaded the database by running the HACF_db_dwl.sh script, the path to your database is: $HOME/db/BLASTx/HA.\033[0m"
    exit 1
fi

mkdir -p ${dirout}
cd ${dirfa}

#------------------------------
# Define paths as variables
#------------------------------

dbHA="IA_H_prot"

echo -e "db used = ${dbHA}"

#--------------------------------------
# Loop for cloning the HA gene from IA
#--------------------------------------

echo -e "\n\033[1;36m========== Searching for gene HA ==========\033[0m\n"

shopt -s nullglob

for assembly in *.fa *.fasta *.fna; do
    ID=$(basename ${assembly} | cut -d '.' -f '1')

echo -e "##### ${ID} #####"

blastx -query ${assembly} \
       -db ${dirdb}/${dbHA} \
       -max_target_seqs 1 -max_hsps 1 \
       -evalue 1e-80 \
       -num_threads 5 \
       -out ${dirout}/${ID}_HA_blastx.tsv \
       -outfmt '6 qseqid sseqid pident length mismatch qstart qend evalue bitscore qseq'

awk '{print ">"$1"_HA""\n"$10}' ${dirout}/${ID}_HA_blastx.tsv > ${dirout}/${ID}_HA_prot.fna

awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"($7+3)"\t"$8"\t"$9"\t""HA"}' ${dirout}/${ID}_HA_blastx.tsv \
> ${dirout}/${ID}_HA_info.tsv

sed -i '1i ID\tReferencia\tIdentidad\tAling_long\tMismatch\tInicio\tFin\te-value\tbitscore\tGen' ${dirout}/${ID}_HA_info.tsv

	done

rm ${dirout}/*_HA_blastx.tsv

#---------------------
#Concatenar resultados
#---------------------

for f in ${dirout}/*_HA_info.tsv; do
    ename=$(basename ${f} | cut -d '_' -f '1')

echo -e "\n########## ${ename} ########## \n$(cat ${f})"
        done >> ${dirout}/Annotation_HA.tsv

rm ${dirout}/*_HA_info.tsv

mkdir -p ${dirout}/Proteins
mv ${dirout}/*.fna ${dirout}/Proteins

echo -e "\033[5;32m#################################################################\033[0m"
echo -e "\033[5;32m========== Annotation of HA gene with BLASTx completed ==========\033[0m"
echo -e "\033[5;32m================== $(date) =================\033[0m"
echo -e "\033[5;32m#################################################################\033[0m"
