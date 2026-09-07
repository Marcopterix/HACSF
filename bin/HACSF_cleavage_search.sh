#!/usr/bin/env bash

echo -e "\n""\033[42m#############################################################################\033[m"
echo -e "\033[42m=============== Prediction of Cleavage Sites and Pathogenicity ==============\033[m"
echo -e "\033[42m====== $(date) =====\033[m"
echo -e "\033[42m#################################################################################\033[m" "\n"

#---------
# Options
#---------

usage () {
echo ""
echo -e "\033[4;33m===== Bash script designed to extract amino acid sequences of the segment 4 (HA) gene of IA virus and predict pathogenicity. =====\033[0m"
echo ""
echo "Pipeline developed in the Massive Sequencing and Bioinformatics area of CENASA, SENASICA."
echo ""
echo -e "\033[4;33mThis is the second step: Identify the cleavage sites and determine the pathogenicity of the influenza A virus.\033[0m"
echo ""
echo "Options:"
echo "Usage: $0 -a AMINO ACID FASTA file PATH -e RESULT OUTDIR PATH -r REFERENCE DB PATH"
echo " -h print help "
echo " -a AMINO ACID FASTA file directory "
echo " -e RESULT OUTPUT directory "
echo " -r PATH to REFERENCE Cleavage Sites database (The file of Cleavage Sites is PATH/TO/HACSF/db/Cleavage_Sites.tsv) "
echo "";
	 }

if [[ $# -eq 0 ]]; then
     usage
   exit 1
fi

while getopts ":ha:e:r:" opt; do
	case ${opt} in
h)
   usage; exit
;;
a)
   dirfa=${OPTARG}
;;
e)
   dirout=${OPTARG}
;;
r)
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
   echo -e "\033[0;31mError: -a and -e cannot be the same PATH.\033[0m"
   exit 1
fi
#
if [[ -z ${dirfa} ]]; then
   echo -e "\033[0;33mError: Option -a is necesary.\033[0m"
   exit 1
fi
#
if [[ -z ${dirout} ]]; then
   echo -e "\033[0;33mError: Option -e is necesary.\033[0m"
   exit 1
fi
#
if [[ -z ${dirdb} ]]; then
   echo -e "\033[0;33mError: Option -r is necesary.\033[0m"
   echo -e "\033[0;33mThe database file of Cleavage Sites is "PATH/TO/HACSF/db/Cleavage_Sites.tsv".\033[0m"
   exit 1
fi

mkdir -p ${dirout}
cd ${dirfa}

#------------------------------------------------
# Determining the cleavage site and pathogenicity
#------------------------------------------------

DB="${dirdb}/Cleavage_Sites.tsv"

echo -e "Reference file = ${DB}"

echo -e "\n\033[1;36m========== Determining the cleavage site and pathogenicity ==========\033[0m\n"

shopt -s nullglob

for a in *.fa* *.fna *.faa; do
    ID=$(basename ${a} | cut -d '.' -f '1')

echo -e "##### ${ID}  #####"

awk '
BEGIN {
        print"Contig\tCleavage_site\tPhenotype\tAssociated_subtype\tNotes";
        FS="\t";
       }

NR==FNR {
          if (FNR > 1)
                       {
                         fen[$1] = $2"\t"$3
                       };  next
        }

/^>/ {
       if (seq != "")
                      { found=0;
                                 for (m in fen) {
                                                  if (index(seq, m)) {
                                                                       print header "\t" m "\t" fen[m]; found=1
                                                                     }
                                                 }
       if (!found) {
                     if ( match (seq, /GLF/)) {
               print header "\tNo_Match\tNo_Match\tNo_Match\t" substr (seq, RSTART -12, 15 ) " ---> Site not found in the DB ";
                                               }
                    };

                       seq=""
                       }; header=$0;  next
       }
          { seq=seq $0
           }


END {
      if (seq != "")
                     { found=0;
                                for (m in fen) {
                                                 if (index(seq, m)) {
                                                                      print header "\t" m "\t" fen[m]; found=1
                                                                    }
                                                }

      if (!found) {
                    if ( match (seq, /GLF/)) {
                print header "\tNo_Match\tNo_Match\tNo_Match\t" substr (seq, RSTART -12, 15 ) " ---> Site not found in the DB ";
                                              }
                   };

                      seq=""
                        }; header=$0
       }
         {seq=seq $0
          }' ${DB} ${a} > ${dirout}/${ID}_HACF.tsv

done
