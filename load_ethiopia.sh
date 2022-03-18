#!/bin/sh

CURRENT=`pwd`

# Fetch Kenya data
echo "Downloading data for Ethiopia..."
curl --create-dirs -o $HOME/downloads/ethiopia-base-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-base-latest.tar.bz2

echo "Extracting data..."
cd /data
tar xjvf $HOME/downloads/ethiopia-base-latest.tar.bz2
echo "DONE!"

cd $CURRENT
