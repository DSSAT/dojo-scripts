#!/usr/bin/env bash

# Modify these variables as needed
ADMLV_LEVEL="ADMLV0"
ADMLV_MATCH="Ethiopia"
CROP_FAILURE_THRESHOLD=200
LOW_PRODUCTION_PER_PERSON=200
# Stop modifying here
RAW_PYTHIA_OUT="/tmp/results"
BASELINE_ANALYSIS_DIR="/data/baseline"
ANALYSIS_DIR="/userdata/out"
CURRENT=`pwd`

# Load the newest weather files
curl --create-dirs -o $HOME/downloads/ethiopia-weather-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-weather-latest.tar.bz2 && \
mkdir /data/ethiopia/weather && \
cd /data/ethiopia/weather && \ 
tar xjvf $HOME/downloads/ethiopia-weather-latest.tar.bz2

# Actually run the pipeline
rm -rf /userdata/out && \
/home/clouseau/.local/bin/pythia --clean-work-dir --all /userdata/pythia.json && \
cd /opt/pythia-analytics && \
/usr/bin/Rscript fix-pythia-outputs.R -o -l 2 -v $ADMLV_LEVEL -u $ADMLV_MATCH -- $RAW_PYTHIA_OUT && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE MGMT HYEAR CR SEASON-v PRODUCTION CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l $LOW_PRODUCTION_PER_PERSON_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_2.csv && \
cd $CURRENT
