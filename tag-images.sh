#!/usr/bin/env bash

IMAGE_PATH="/userdata/images/"

# === DO NOT MODIFY BELOW THIS LINE ===
CURRENT=$(pwd)
PREAMBLE="This image shows the model's sensitivity response to "

cd ${IMAGE_PATH}
for f in *; do
    echo $f
    v=$(echo $f | awk -F'-' '{print $1}' | sed 's/_/ /g')
    case $v in
    "planting date")
        desc="shifting the planting date"
        ;;
    "fertilizer")
        desc="increased fertilizer[N] amounts"
        ;;
    *)
        echo "error: unsupport variable ($v)" 1>&2
        exit 1
        ;;
    esac
    e=$(echo $f | grep -c 'Ethiopia')
    r=$(echo $f | awk -F'-' '{print $2}' | sed 's/\.png//g' | sed 's/_/ /g' | sed 's/Nations/Nations,/g')
    if [[ $e -eq 1 ]]; then
        desc="${desc} for all of Ethiopia's growing regions."
    else
        desc="${desc} for the ${r} region."
    fi
    dojo tag "${f}" "${PREAMBLE}${desc}"
done

cd ${CURRENT}
