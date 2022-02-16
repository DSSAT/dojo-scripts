#!/usr/bin/env bash

# This is a minimized version of the entire pipeline. We are currently working on how to get the visualization for the different
# levels of output to work as we want in the visualization system. Until that time, we are only providing the minimally processed
# data.

# Modify these variables as needed
ADMLV_LEVEL="ADMLV0"
ADMLV_MATCH="Ethiopia"
CROP_FAILURE_THRESHOLD=200
LOW_PRODUCTION_PER_PERSON=200

# Stop modifying here
WEATHER_PATH="/data/ethiopia/weather"
PYTHIA_PP="pp.csv"
RAW_PYTHIA_DIR="/tmp/results"
RAW_PYTHIA_OUT="/userdata/out"
PYTHIA_OUT_FILE="${RAW_PYTHIA_DIR}/${PYTHIA_PP}"
BASELINE_ANALYSIS_DIR="/data/baseline"
ANALYSIS_DIR="/userdata/out"
CURRENT=`pwd`

# Load the newest weather files
curl --create-dirs -o $HOME/downloads/ethiopia-weather-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-weather-latest.tar.bz2 && \
mkdir $WEATHER_PATH && \
cd $WEATHER_PATH && \ 
tar xjvf $HOME/downloads/ethiopia-weather-latest.tar.bz2
rm $HOME/downloads/ethiopia-weather-latest.tar.bz2

# Actually run the pipeline
rm -rf $RAW_PYTHIA_OUT && \
mkdir -p $RAW_PYTHIA_OUT && \
pythia --clean-work-dir --all /userdata/pythia.json && \
cp "${RAW_PYTHIA_DIR}/${PYTHIA_PP}" $PYTHIA_OUT_FILE
cd /opt/pythia-analytics && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE MGMT HYEAR CR SEASON-v PRODUCTION CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l $LOW_PRODUCTION_PER_PERSON_THRESHOLD -- $PYTHIA_OUT_FILE $ANALYSIS_DIR/stage_2.csv && \
rm -rf $RAW_PYTHIA_DIR && \
rm -rf $WEATHER_PATH && \
cd $CURRENT
