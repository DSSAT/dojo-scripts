!/usr/bin/env bash

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
ORIG_PYTHIA_DIR="/tmp/results"
NEW_PYTHIA_DIR="/userdata/out"
WORK_FILE="${NEW_PYTHIA_DIR}/${PYTHIA_PP}"
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
rm -rf $NEW_PYTHIA_DIR/* && \
mkdir -p $NEW_PYTHIA_DIR
cd $HOME && \
pythia --clean-work-dir --all /userdata/pythia.json && \
cp "${ORIG_PYTHIA_DIR}/${PYTHIA_PP}" $WORK_FILE
cd /opt/pythia-analytics && \
    # Assign Admin Level
    /usr/bin/Rscript fix-pythia-outputs.R -o -l 2 -v $ADMLV_LEVEL -u $ADMLV_MATCH $WORK_FILE
    
    # Per pixel non-aggregated values
    /usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE MGMT HYEAR CR SEASON -v PRODUCTION CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l $LOW_PRODUCTION_PER_PERSON -- $WORK_FILE $ANALYSIS_DIR/stage_2.csv && \

    /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV2 MGMT HYEAR CR SEASON -v PRODUCTION CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l $LOW_PRODUCTION_PER_PERSON -- $WORK_FILE $ANALYSIS_DIR/stage_7.csv
    
rm -rf $ORIG_PYTHIA_DIR
rm -rf $WEATHER_PATH
cd $CURRENT
