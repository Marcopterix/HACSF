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
---> Entrez Direct to download the HA database (https://www.ncbi.nlm.nih.gov/books/NBK179288/)***


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

# Using and Running the Pipeline

This pipeline consists of two steps: annotation to determine the correct reading frame and pathogenicity assessment.

For the first step, in which the nucleotide sequence will be converted into a protein
```
bash HACSF_BLASTx_annotate.sh -f FASTA file PATH -o OUTDIR PATH -p BLAST DB PATH"

Options:
Usage: HACSF_BLASTx_annotate.sh -f FASTA file PATH -o OUTDIR PATH -p BLAST DB PATH
 -h print help 
 -f FASTA file directory 
 -o OUTPUT directory 
 -p PATH to BLAST database. If you downloaded the database by running the HACF_db_dwl.sh script, the path to your database is: $HOME/db/BLASTx/HA
```

In the second step, the cleavage site and pathogenicity will be determined based on its amino acid sequence (protein)
```
bash HACSF_cleavage_search.sh -a AMINO ACID FASTA file PATH -e RESULT OUTDIR PATH -r REFERENCE DB PATH

Options:
Usage: HACSF_cleavage_search.sh -a AMINO ACID FASTA file PATH -e RESULT OUTDIR PATH -r REFERENCE DB PATH
 -h print help 
 -a AMINO ACID FASTA file directory 
 -e RESULT OUTPUT directory 
 -r PATH to REFERENCE Cleavage Sites database (The file of Cleavage Sites is /db/Cleavage_Sites.tsv) 
```

# Output Files

At the end of the first pipline process, in the directory you specified with the ***-o*** you will find









