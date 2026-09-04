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
