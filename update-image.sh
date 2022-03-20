#!/bin/sh

# Create working directories
sudo mkdir /userdata && sudo mkdir /data && \
sudo chown -R clouseau /opt && sudo chown -R clouseau /data && sudo chown -R clouseau /userdata

# Download the base data to the image
curl --create-dirs -o $HOME/downloads/global-base-latest.tar.bz2 https://data.agmip.org/darpa/global-base-latest.tar.bz2
    
# Download the scripts from git
cd /usr/local/src && \
    sudo git clone https://github.com/DSSAT/dojo-scripts && \
    chown -R clouseau dojo-scripts

sudo ln -s /usr/local/src/dojo-scripts/pipeline.sh /usr/local/bin/pipeline
sudo ln -s /usr/local/src/dojo-scripts/load_ethiopia.sh /usr/local/bin/load_ethiopia

# Handle the user install of R packages
cd /opt/pythia-analytics && \
Rscript install-deps.R

cd $HOME
