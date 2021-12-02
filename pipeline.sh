#!/usr/bin/env bash

CURRENT=`pwd`

rm -f /userdata/out/report.csv
/home/clouseau/.local/bin/pythia --clean-work-dir --all /userdata/pythia.json && \
cd /opt/pythia-analytics && \
/usr/bin/Rscript fix-pythia-outputs.R /tmp/results && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f LATITUDE LONGITUDE RUN_NAME HYEAR -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM -- /tmp/results /userdata/scenario_agg_by_mgmt_pixel.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV0 RUN_NAME HYEAR -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM -- /tmp/results /userdata/scenario_agg_by_mgmt_admin0.csv && \
/usr/bin/Rscript aggregate-pythia-outputs.R -f ADMLV1 RUN_NAME HYEAR -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM -- /tmp/results /userdata/scenario_agg_by_mgmt_admin1.csv && \
/usr/bin/Rscript diff-pythia-output.R /data/baseline/baseline_agg_by_mgmt_pixel.csv /userdata/scenario_agg_by_mgmt_pixel.csv /userdata/diff_pixel.csv && \
/usr/bin/Rscript diff-pythia-output.R /data/baseline/baseline_agg_by_mgmt_admin0.csv /userdata/scenario_agg_by_mgmt_admin0.csv /userdata/diff_admin0.csv && \
/usr/bin/Rscript diff-pythia-output.R /data/baseline/baseline_agg_by_mgmt_admin1.csv /userdata/scenario_agg_by_mgmt_admin1.csv /userdata/diff_admin1.csv && \
/usr/bin/Rscript stats-pythia-outputs.R /userdata/scenario_agg_by_mgmt_admin0.csv /userdata/scenario_stats_admin0.csv -i -f ADMLV0 -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM && \
/usr/bin/Rscript stats-pythia-outputs.R /userdata/scenario_agg_by_mgmt_admin1.csv /userdata/scenario_stats_admin1.csv -i -f ADMLV1 -v PRODUCTION CROP_PER_PERSON -t HARVEST_AREA -o NICM -a HWAM && \
/usr/bin/Rscript statplot-pythia-outputs.R /data/baseline/baseline_stats_admin0.csv /userdata/scenario_stats_admin0.csv /userdata/boxplots -f ADMLV0 && \
/usr/bin/Rscript statplot-pythia-outputs.R /data/baseline/baseline_stats_admin1.csv /userdata/scenario_stats_admin1.csv /userdata/boxplots -f ADMLV1 && \
cd $CURRENT
