#!/usr/bin/env bash

for f in *; do
   v=$(echo $f | sed -e 's/[_]\+/-/g' | sed -e 's/ing-da/ing_da/g' | sed -e 's/[,\ ]\+/_/g')
   mv "$f" $v
done
