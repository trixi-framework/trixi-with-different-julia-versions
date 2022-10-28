#!/bin/bash

set -eo pipefail

for i in 1 2 3; do
  for version in 1.7.3 1.8.2 1.9-2ac105a3f6; do
    rm -rf install-$version-latest && mkdir install-$version-latest
    cd install-$version-latest && ../setup.sh julia-$version && cd ..
    echo "-----------------------------------------------------------------------------------------"
    echo "^^^ These are the results for trial #$i in install-$version-latest/ ^^^"
    echo "-----------------------------------------------------------------------------------------"
  done
done
