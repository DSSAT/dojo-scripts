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

rm -f /userdata/out/report.csv
/home/clouseau/.local/bin/pythia --clean-work-dir --all /userdata/pythia.json && \
cd /opt/pythia-analytics && \
/usr/bin/Rscript fix-pythia-outputs.R -o -l 2 -v ADMLV0 -u Ghana $RAW_PYTHIA_OUT && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE RUN_NAME HYEAR CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -l LOW_PRODUCTION_PER_PERSON_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_2.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE HYEAR CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_3.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE RUN_NAME CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_4.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_5.csv && \
/usr/bin/Rscript diff-pythia-output.R $BASELINE_ANALYSIS_DIR/stage_5.csv $ANALYSIS_DIR/stage_5.csv $ANALYSIS_DIR/stage_6.csv && \
for a in {0..2}; do /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV$a RUN_NAME HYEAR CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_7_admlv$a.csv; done && \
for a in {0..2}; do /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV$a HYEAR CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_8_admlv$a.csv; done && \
for a in {0..2}; do /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV$a RUN_NAME CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_9_admlv$a.csv; done && \
for a in {0..2}; do /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV$a CR -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -c $CROP_FAILURE_THRESHOLD -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_10_admlv$a.csv; done && \
for a in {0..2}; do /usr/bin/Rscript diff-pythia-output.R $BASELINE_ANALYSIS_DIR/stage_10_admlv$a.csv $ANALYSIS_DIR/stage_10_admlv$a.csv $ANALYSIS_DIR/stage_11_admlv$a.csv; done && \
for a in {0..2}; do /usr/bin/Rscript stats-pythia-outputs.R -i -f ADMLV$a -v PRODUCTION CROP_PER_PERSON CROP_PER_DROP CROP_FAILURE_AREA -t HARVEST_AREA -o NICM -a HWAM -- $ANALYSIS_DIR/stage_8_admlv$a.csv $ANALYSIS_DIR/stage_12_admlv$a.csv; done && \
for a in {0..2}; do /usr/bin/Rscript statplot-pythia-outputs.R $BASELINE_ANALYSIS_DIR/stage_8_admlv$a.csv $ANALYSIS_DIR/stage_8_admlv$a.csv $ANALYSIS_DIR/images/; done && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE HYEAR HMONTH CR -v PRODUCTION -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_13.csv && \
for a in {0..2}; do /usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV$a HMONTH HYEAR CR -v PRODUCTION -- $RAW_PYTHIA_OUT $ANALYSIS_DIR/stage_14_admlv$a.csv; done && \ 
for a in {0..2}; do /usr/bin/Rscript stats-pythia-outputs.R -i -f ADMLV$a HMONTH -v PRODUCTION -- $ANALYSIS_DIR/stage_14_admlv$a.csv $ANALYSIS_DIR/stage_15_admlv$a.csv; done && \
for a in {0..1}; do /usr/bin/Rscript monthlyplot-pythia-outputs.R -f ADMLV$a -- $ANALYSIS_DIR/stage_14_admlv$a.csv $ANALYSIS_DIR/images; done
cd $CURRENT
