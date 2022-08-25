#!/bin/bash

ORDINARYDIFFEQ_VERSION=6.19.3
# ORDINARYDIFFEQ_VERSION=6.24.0
TRIXI_VERSION=0.4.44

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
echo "ORDINARYDIFFEQ.JL: $ORDINARYDIFFEQ_VERSION"
echo "TRIXI.JL:          $TRIXI_VERSION"

echo
echo "################################################################################"
echo "Installing OrdinaryDiffEq.jl..."
echo "################################################################################"
set -x
time -p JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. -e \
  "using Pkg; Pkg.add(name=\"OrdinaryDiffEq\", version=\"$ORDINARYDIFFEQ_VERSION\")"

echo
echo "################################################################################"
echo "Installing Trixi.jl..."
echo "################################################################################"
set -x
time -p JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. -e \
  "using Pkg; Pkg.add(name=\"Trixi\", version=\"$TRIXI_VERSION\")"
