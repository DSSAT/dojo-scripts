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
ORIG_PYTHIA_DIR="/tmp/results"
NEW_PYTHIA_DIR="/userdata/out"
WORK_FILE="${NEW_PYTHIA_DIR}/${PYTHIA_PP}"
BASELINE_ANALYSIS_DIR="/data/baseline"
ANALYSIS_DIR="/userdata/out"
CURRENT=`pwd`
SA_BASELINE=("0" "1.0" "0")
CC_BASELINE=("0.0" "1.0")
F_BASELINE=("2022-01-01")
BASELINE_IMAGE_SRC="/data/ethiopia/images"
BASELINE_IMAGE_DEST="/userdata/images"

display_help() {
    echo
    echo "pipeline - A DSSAT-pythia harness for the Dojo environment"
    echo
    echo "Usage: pipeline mode arg1 [arg2] [arg3]"
    echo "mode          sa, cc, f"
    echo "arg1          F,  T,  F"
    echo "arg2          R,  R,  -"
    echo "arg3          P,  -,  -"
    echo
}

bail() {
    display_help
    echo -e "$1" 1>&2
    exit 1
}

check_for_number() {
    cfnr=0
    for i in "${!args[@]}"; do
        v=$(echo ${args[$i]} | grep -c '^[-]\?[0-9\.]\+$')
        if [[ $v -ne 1 ]]; then
            err="${err}error: argument in position $((i + 1)) (${args[$i]}) should be a number.\n"
            cfnr=1
        fi
    done
    if [[ cfnr -eq 1 ]]; then
        bail "${err[@]}"
    fi
}

check_for_isodate() {
    cfdr=0
    for i in "${!args[@]}"; do
        v=$(echo ${args[$i]} | grep -c '^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$')
        if [[ $v -ne 1 ]]; then
            err="${err}error: argument in position $((i + 1)) (${args[$i]}) should be a valid ISO date (YYYY-mm-dd).\n"
            cfdr=1
        fi
    done
    if [[ cfdr -eq 1 ]]; then
        bail "${err[@]}"
    fi
}

if [ -z $1 ]; then
    bail "error: invalid parameters"
fi

# Check to make sure the parameters are correct
raw_args=("$@")
mode="${raw_args[0]}"
args=("${raw_args[@]:1}")
argl="${#args[@]}"
echo "Mode: $mode"
echo "Args: ${args[@]}"
echo "Argsl: $argl"

case $mode in
"sa")
    echo -n "checking SA parameters..."
    if [[ $argl -ne 3 ]]; then
        bail "error: invalid number of parameters for SA mode. Expected 3, found $argl."
    fi
    check_for_number
    echo "DONE"
    baseline_check=("${SA_BASELINE[@]}")
    ;;
"cc")
    echo -n "checking CC parameters..."
    if [[ $argl -ne 2 ]]; then
        bail "error: invalid number of parameters for CC mode. Expected 2, found $((args - 1))."
    fi
    check_for_number
    echo "DONE"
    baseline_check=("${CC_BASELINE[@]}")
    ;;
"f")
    echo -n "checking F parameters..."
    if [[ $argl -ne 1 ]]; then
        bail "error: invalid number of parameters for F mode. Expected 1, found $((args - 1))"
    fi
    check_for_isodate
    echo "DONE"
    baseline_check=("${F_BASELINE[@]}")
    ;;
*)
    bail "error: invalid mode parameter"
    ;;
esac

echo -n "baseline run..."
is_baseline=0
for i in "${!args[@]}"; do
    if [ "${baseline_check[$i]}" != "${args[$i]}" ]; then
        is_baseline=1
    fi
done
if [[ $is_baseline -eq 1 ]]; then
    echo "FALSE"
else
    echo "TRUE"
fi

echo "Executing run"
echo "---"

# Load the newest weather files
echo "Downloading the weather files"
curl --create-dirs -so $HOME/downloads/ethiopia-weather-latest.tar.bz2 https://data.agmip.org/darpa/ethiopia-weather-latest.tar.bz2 && \
mkdir $WEATHER_PATH && \
cd $WEATHER_PATH && \
echo -n "Extracting weather files..."
tar xjf $HOME/downloads/ethiopia-weather-latest.tar.bz2
echo "DONE"
rm $HOME/downloads/ethiopia-weather-latest.tar.bz2

# Replace templated values inside the pythia.json file.
echo "Replacing template information..."
sed -i.bak "s/~f_i~/${args[0]}/g" /userdata/pythia.json &&
sed -i "s/~p_m~/${args[1]}/g" /userdata/pythia.json &&
sed -i "s/~pd_s~/${args[2]}/g" /userdata/pythia.json
echo "DONE"

# Actually run the pipeline
rm -rf $NEW_PYTHIA_DIR/* && \
mkdir -p $NEW_PYTHIA_DIR
cd $HOME && \
pythia --clean-work-dir --all /userdata/pythia.json && \
cp "${ORIG_PYTHIA_DIR}/${PYTHIA_PP}" $WORK_FILE
cd /opt/pythia-analytics && \
    # Assign Admin Level
    /usr/bin/Rscript fix-pythia-outputs.R -o -l 2 -v $ADMLV_LEVEL -u $ADMLV_MATCH -c -- $WORK_FILE && \
    
    # Per pixel non-aggregated values
    /usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE MGMT HYEAR CR SEASON -v PRODUCTION CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l $LOW_PRODUCTION_PER_PERSON -- $WORK_FILE $ANALYSIS_DIR/stage_2.csv && \

    /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV2 MGMT HYEAR CR SEASON -v PRODUCTION CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l $LOW_PRODUCTION_PER_PERSON -- $WORK_FILE $ANALYSIS_DIR/stage_7.csv
    
rm -rf $ORIG_PYTHIA_DIR
rm -rf $WEATHER_PATH
mv /userdata/pythia.json.bak /userdata/pythia.json

if [[ $is_baseline -eq 0 ]]; then
    echo -n "Copying images to be tagged for baseline runs..."
    cp -r $BASELINE_IMAGE_SRC $BASELINE_IMAGE_DEST
    echo "DONE"
fi

cd $CURRENT
