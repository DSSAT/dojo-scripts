#!/bin/sh

CURRENT=`pwd`

# Fetch Kenya data
echo "Downloading data for Ethiopia..."
curl --create-dirs -o $HOME/downloads/ethiopia-runs-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-runs-latest.tar.bz2
curl --create-dirs -o $HOME/downloads/ethiopia-base-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-base-latest.tar.bz2
curl --create-dirs -o $HOME/downloads/ethiopia-weather-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-weather-latest.tar.bz2

echo "Extracting data..."
cd /data
tar xjvf $HOME/downloads/ethiopia-base-latest.tar.bz2
mkdir /data/ethiopia/weather
cd /data/ethiopia/weather
tar xjvf $HOME/downloads/ethiopia-weather-latest.tar.bz2
cd /userdata
tar xjvf $HOME/downloads/ethiopia-runs-latest.tar.bz2
echo "DONE!"

cd $CURRENT
