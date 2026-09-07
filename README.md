# HA Cleavage Site Finder (HACSF)
HA Cleavage Site Finder is a bioinformatics workflow developed to identify cleavage sites in the hemagglutinin gene of the influenza A virus (IA) and infer its pathogenicity. The database used for prediction is based on the latest version (2022, to date) of: OFFLU. (2022). Influenza A Cleavage Sites. Version 4th January 2022.



# Installation:
To clone this repository, run:

```
 git clone https://github.com/Marcopterix/HACSF
```

Once you have cloned the repository, navigate to the ***HACSF/bin*** directory and grant the script execute permission:

```
 chmod +x ./*sh
```

It's also important to add this folder to the PATH in your ***~/.bashrc***:

```
nano ~/.bashrc

# Once you are editing your ~/.bashrc, paste the following line into the section where your paths are listed,
# replacing “$HOME/PATH_TO/HACSF/bin” with the full path where you cloned your repository.
# To find this path, navigate to the bin directory, and once there, type the command pwd in the terminal.

export PATH="$HOME/PATH_TO/HACSF/bin:$PATH"

source ~/.bashrc

```



# Required dependencies:

You must have the following programs installed, and you ***must also add the binaries for these programs to your PATH***:


***---> BLAST+ to run BLASTx (https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html#blast-executables)  
---> Entrez Direct to download the HA database (https://www.ncbi.nlm.nih.gov/books/NBK179288/)  
---> seqkit (https://bioinf.shenwei.me/seqkit/download/)***




# Prepare the Database

Once you have installed the necesary dependencies, you must run the ***HACSF_db_dwl.sh*** script as follows:

```
bash HACSF_db_dwl.sh
```

This will download the databases to the $HOME/db/BLASTx/HA folder. If you'd like, you can add the path to these generated files to your ~/.bashrc file as follows:

```
nano ~/.bashrc

export Bx_HACSF_PATH="$HOME/db/BLASTx/HA"

source ~/.bashrc
```




# 1- Using and Running the first step

This pipeline consists of two steps: annotation to determine the correct reading frame and pathogenicity assessment.

For the first step, in which the nucleotide sequence will be converted into a protein. 
Let's assume that:  
The path to your fasta files is: $HOME/projects/fasta/IA_HACS;   
your output path is: $HOME/projects/fasta/IA_HACS/BLASTx_results;   
and the path to the BLASTx database when running the HACSF_db_dwl.sh pipeline would be: $HOME/db/BLASTx/HA. You'll need to run the script as follows
```
bash HACSF_BLASTx_annotate.sh \  
     -f $HOME/projects/fasta/IA_HACS \
     -o $HOME/projects/fasta/IA_HACS/BLASTx_results \
     -p $HOME/db/BLASTx/HA
```



# Output Files of the first step
In the directory you specified with the “-o” option, you'll find an Annotation_HA.tsv file, as well as a “Proteins” directory containing the FASTA files of the protein sequences (.fna).




# 2- Using and Running the second step
In the second step, the cleavage site and pathogenicity will be determined based on its amino acid sequence (protein).
In this case, following the previous step, the output of:  
Your FASTA files containing protein sequences would be: $HOME/projects/fasta/IA_HACS/BLASTx_results/Proteins;   
that the output path you would like is: $HOME/projects/IA_HACS/HACF_out;   
and finally, the path to the reference file containing information on cleavage sites and their phenotype (HACSF/db/Cleavage_Sites.tsv): $HOME/bioinformatics_tools/HACSF/db (You don't need to specify the file name, JUST THE PATH, since the pipeline identifies it automatically). 
```
bash HACSF_cleavage_search.sh \
     -a $HOME/projects/fasta/IA_HACS/BLASTx_results/Proteinas \
     -e $HOME/projects/IA_HACS/HACF_out \
     -r $HOME/bioinformatics_tools/HACSF/db
```




# Output Files of the second step
At the end of the second run, in the directory you specified as the output directory using the “-e” option, you will find the generated “.tsv” files, which contain the contig name, information about the identified cleavage site (if a match was found with one in the reference file), its associated phenotype (HP/LP), the subtypes associated with that cleavage site and, if no similarity was found, information regarding the site found in the NOTES section.






