#!/bin/sh

CURRENT=`pwd`

# Fetch Kenya data
echo "Downloading data for Ethiopia..."
curl --create-dirs -o $HOME/downloads/ethiopia-runs-latest.tar.xz https://data.agmip.org/darpa/ethiopia-runs-latest.tar.xz
curl --create-dirs -o $HOME/downloads/ethiopia-base-latest.tar.xz https://data.agmip.org/darpa/ethiopia-base-latest.tar.xz
curl --create-dirs -o $HOME/downloads/ethiopia-weather-latest.tar.xz https://data.agmip.org/darpa/ethiopia-weather-latest.tar.xz

echo "Extracting data..."
cd /data
tar xvf $HOME/downloads/ethiopia-base-latest.tar.xz
mkdir /data/ethiopia/weather
cd /data/ethiopia/weather
tar xvf $HOME/downloads/ethiopia-weather-latest.tar.xz
cd /userdata
tar xvf $HOME/downloads/ethiopia-runs-latest.tar.xz
echo "DONE!"

cd $CURRENT
