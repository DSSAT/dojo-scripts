#!/usr/bin/env bash

CURRENT=`pwd`

sed '/workDir/ s/\/tmp\/results/\/data\/baseline\/out/' /userdata/pythia.json > /userdata/baseline.json

rm -rf /data/baseline/ && \
/home/clouseau/.local/bin/pythia --all /userdata/baseline.json && \
cd /opt/pythia-analytics && \
/usr/bin/Rscript fix-pythia-outputs.R /data/baseline/out && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE RUN_NAME HYEAR -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM -- /data/baseline/out /data/baseline/baseline_agg_by_mgmt_pixel.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV0 RUN_NAME HYEAR -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM -- /data/baseline/out /data/baseline/baseline_agg_by_mgmt_admin0.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV1 RUN_NAME HYEAR -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM -- /data/baseline/out //data/baseline/baseline_agg_by_mgmt_admin1.csv && \
/usr/bin/Rscript diff-pythia-output.R /data/baseline/baseline_agg_by_mgmt_pixel.csv //data/baseline/baseline_agg_by_mgmt_pixel.csv /userdata/diff_pixel.csv && \
/usr/bin/Rscript diff-pythia-output.R /data/baseline/baseline_agg_by_mgmt_admin0.csv //data/baseline/baseline_agg_by_mgmt_admin0.csv /userdata/diff_admin0.csv && \
/usr/bin/Rscript diff-pythia-output.R /data/baseline/baseline_agg_by_mgmt_admin1.csv //data/baseline/baseline_agg_by_mgmt_admin1.csv /userdata/diff_admin1.csv && \
/usr/bin/Rscript stats-pythia-outputs.R /data/baseline/baseline_agg_by_mgmt_admin0.csv /data/baseline/baseline_stats_admin0.csv -i -f ADMLV0 -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM
/usr/bin/Rscript stats-pythia-outputs.R /data/baseline/baseline_agg_by_mgmt_admin1.csv /data/baseline/baseline_stats_admin1.csv -i -f ADMLV0 -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM
cd $CURRENT
