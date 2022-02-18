#!/bin/sh

# Create working directories
sudo mkdir /userdata && sudo mkdir /data && \
sudo chown -R clouseau /opt && sudo chown -R clouseau /data && sudo chown -R clouseau /userdata

# Download the base data to the image
curl --create-dirs -o $HOME/downloads/global-base-latest.tar.bz2 https://data.agmip.org/darpa/global-base-latest.tar.bz2 && \
cd /data && tar xjvf $HOME/downloads/global-base-latest.tar.bz2

# Download the scripts from upstream
sudo curl --create-dirs -o /usr/local/bin/load_kenya https://data.agmip.org/darpa/dojo/load_kenya.sh
sudo curl --create-dirs -o /usr/local/bin/load_ethiopia https://data.agmip.org/darpa/dojo/load_ethiopia.sh
sudo curl --create-dirs -o /usr/local/bin/pipeline https://data.agmip.org/darpa/dojo/pipeline.sh
sudo curl --create-dirs -o /usr/local/bin/baseline https://data.agmip.org/darpa/dojo/baseline.sh
sudo chmod 755 /usr/local/bin/load_kenya && sudo chown clouseau /usr/local/bin/load_kenya
sudo chmod 755 /usr/local/bin/load_ethiopia && sudo chown clouseau /usr/local/bin/load_ethiopia
sudo chmod 755 /usr/local/bin/pipeline  && sudo chown clouseau /usr/local/bin/pipeline
sudo chmod 755 /usr/local/bin/baseline && sudo chown clouseau /usr/local/bin/baseline

# Handle the user install of R packages
sudo chown -R /opt && \
cd /opt/pythia-analytics && \
Rscript install-deps-lite.R

cd $HOME
