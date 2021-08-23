#!/usr/bin/env bash

CURRENT=`pwd`

rm -f /userdata/out/report.csv
/home/clouseau/.local/bin/pythia --clean-work-dir --all /userdata/pythia.json && \
cd /opt/pythia-analytics && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE RUN_NAME HYEAR -v PRODUCTION -t HARVEST_AREA -o NICM -a HWAM HDAT -g /data/base/gadm -- /tmp/results /userdata/out/report.csv && \
cd $CURRENT
