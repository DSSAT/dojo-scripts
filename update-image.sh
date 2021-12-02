#!/bin/sh

sudo apt update && \
sudo apt install -y --no-install-recommends build-essential gfortran cmake \
python3-pip \
r-base libcurl4-openssl-dev libgdal-dev libudunits2-dev libssl-dev
sudo mkdir /userdata && sudo mkdir /data && \
sudo chown clouseau /opt && sudo chown clouseau /data && sudo chown clouseau /userdata

# Install DSSAT
cd $HOME && mkdir src && cd src && \
git clone https://github.com/DSSAT/dssat-csm-os && \
cd dssat-csm-os && git checkout e595e1b37cfb012ae466a3c3a2764f4b1624ffab -b 4.8.0.17 && \
mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/opt/dssat -DCMAKE_BUILD_TYPE=RELEASE .. && \
make && make install

# Install pythia
curl -sSL https://install.python-poetry.org | python3 - && \
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
export PATH="$HOME/.local/bin:$PATH" && \
cd $HOME/src && git clone https://github.com/DSSAT/pythia && cd pythia && \
poetry build && cd dist && pip3 install --user pythia-2.0.0b0-py3-none-any.whl

# Install pythia-analytics
cd /opt && git clone https://github.com/DSSAT/supermaas-aggregate-pythia-outputs pythia-analytics && \
cd pythia-analytics && git checkout develop && Rscript install-deps-lite.R

# Download the base data to the image
curl --create-dirs -o $HOME/downloads/global-base-latest.tar.bz2 https://data.agmip.org/darpa/global-base-latest.tar.bz2 && \
cd /data && tar xjvf $HOME/downloads/global-base-latest.tar.bz2

# Download the scripts from upstream
sudo curl --create-dirs -o /usr/local/bin/load_kenya https://data.agmip.org/darpa/load_kenya.sh
sudo curl --create-dirs -o /usr/local/bin/load_ethiopia https://data.agmip.org/darpa/load_ethiopia.sh
sudo curl --create-dirs -o /usr/local/bin/pipeline https://data.agmip.org/darpa/pipeline.sh
sudo curl --create-dirs -o /usr/local/bin/baseline https://data.agmip.org/darpa/baseline.sh
sudo chmod 755 /usr/local/bin/load_kenya && sudo chown clouseau /usr/local/bin/load_kenya
sudo chmod 755 /usr/local/bin/load_ethiopia && sudo chown clouseau /usr/local/bin/load_ethiopia
sudo chmod 755 /usr/local/bin/pipeline  && sudo chown clouseau /usr/local/bin/pipeline
sudo chmod 755 /usr/local/bin/baseline && sudo chown clouseau /usr/local/bin/baseline

cd $HOME
