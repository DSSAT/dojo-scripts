#!/bin/sh

# Create working directories
sudo mkdir /userdata && \
    sudo mkdir /data && \
    sudo chown -R clouseau /opt && \
    sudo chown -R clouseau /data && \
    sudo chown -R clouseau /userdata && \
    sudo chown -R clouseau /usr/local/src

# Handle the user install of R packages
cd /opt/pythia-analytics && \
    Rscript install-deps.R

cd $HOME
