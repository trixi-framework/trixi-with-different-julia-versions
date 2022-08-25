#!/bin/bash

set -eo pipefail

for i in 1 2 3; do
  echo
  echo
  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Trial #$i <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  # cd julia-1.7 && ../ttfx.sh julia-1.7 --check-bounds=no && cd ..
  # echo
  # echo "^^^ These are the results for trial #$i in julia-1.7/ ^^^"
  # echo
  # echo
  # cd julia-1.8 && ../ttfx.sh julia-1.8 --check-bounds=no && cd ..
  # echo
  # echo "^^^ These are the results for trial #$i in julia-1.8/ ^^^"
  # echo
  # echo
  # cd julia-1.8-M1.7 && ../ttfx.sh julia-1.8 --check-bounds=no && cd ..
  # echo
  # echo "^^^ These are the results for trial #$i in julia-1.8-M1.7/ ^^^"
  # echo
  # echo
  cd julia-1.8-latest && ../ttfx.sh julia-1.8 --check-bounds=no && cd ..
  echo
  echo "^^^ These are the results for trial #$i in julia-1.8-latest/ ^^^"
done
