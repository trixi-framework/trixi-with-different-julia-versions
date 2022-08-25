#!/bin/bash

set -eo pipefail

if [ $# -lt 1 ]; then
  echo "ERROR: missing argument: Julia executable" >&2
  exit 2
fi
JULIA_EXECUTABLE="$(which $1)"
if [ $? -eq 1 ]; then
  echo "ERROR: '$1' is either not executable or was not found in PATH" >&2
  exit 2
fi

DEPOT_PATH="$PWD/local_julia_depot"
JULIA_VERSION="$($JULIA_EXECUTABLE --version | awk  '{print $3}')"

echo "JULIA EXECUTABLE:  $JULIA_EXECUTABLE"
echo "JULIA VERSION:     $JULIA_VERSION"
echo "PWD:               $PWD"
echo "DEPOT_PATH:        $DEPOT_PATH"

echo
echo "################################################################################"
echo "Instantiating..."
echo "################################################################################"
time -p \
  JULIA_DEPOT_PATH=$DEPOT_PATH \
  $JULIA_EXECUTABLE --project=. -e \
  "using Pkg; Pkg.instantiate()"
