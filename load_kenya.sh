#!/bin/sh

CURRENT=`pwd`

# Fetch Kenya data
echo "Downloading data for Kenya..."
curl --create-dirs -o $HOME/downloads/kenya-runs-latest.tar.xz https://data.agmip.org/darpa/kenya-runs-latest.tar.xz
curl --create-dirs -o $HOME/downloads/kenya-base-latest.tar.xz https://data.agmip.org/darpa/kenya-base-latest.tar.xz
curl --create-dirs -o $HOME/downloads/kenya-weather-latest.tar.xz https://data.agmip.org/darpa/kenya-weather-latest.tar.xz

echo "Extracting data..."
cd /data
tar xvf $HOME/downloads/kenya-base-latest.tar.xz
mkdir /data/kenya/weather
cd /data/kenya/weather
tar xvf $HOME/downloads/kenya-weather-latest.tar.xz
cd /userdata
tar xvf $HOME/downloads/kenya-runs-latest.tar.xz
echo "DONE!"

cd $CURRENT
