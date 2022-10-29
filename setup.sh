#!/bin/bash

# ORDINARYDIFFEQ_VERSION=6.19.3
# ORDINARYDIFFEQ_VERSION=6.24.0
ORDINARYDIFFEQ_VERSION=6.29.3
# TRIXI_VERSION=0.4.44
TRIXI_VERSION=0.4.50

LOG_NAME=results.txt

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
shift

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
echo "Update registry..."
echo "################################################################################"
set -x
JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. $@ -e \
  "
   using Pkg; Pkg.Registry.add(\"General\")
   open(\"$LOG_NAME\", \"a\") do f
     println(f, \"-\"^80)
   end
  "
set +x

echo
echo "################################################################################"
echo "Installing OrdinaryDiffEq.jl..."
echo "################################################################################"
set -x
JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. $@ -e \
  "
   using Pkg
   print(\"Adding OrdinaryDiffEq... \")
   add_ordinarydiffeq = @elapsed Pkg.add(name=\"OrdinaryDiffEq\", version=\"$ORDINARYDIFFEQ_VERSION\", io=devnull)
   println(\"done\")
   print(\"Using OrdinaryDiffEq... \")
   using_ordinarydiffeq = @elapsed using OrdinaryDiffEq
   println(\"done\")
   println()
   @show add_ordinarydiffeq
   @show using_ordinarydiffeq
   open(\"$LOG_NAME\", \"a\") do f
     println(f, \"add_ordinarydiffeq = \", add_ordinarydiffeq)
     println(f, \"using_ordinarydiffeq = \", using_ordinarydiffeq)
   end
  "
set +x

echo
echo "################################################################################"
echo "Installing Trixi.jl..."
echo "################################################################################"
set -x
JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. $@ -e \
  "
   using Pkg
   print(\"Adding Trixi... \")
   add_trixi = @elapsed Pkg.add(name=\"Trixi\", version=\"$TRIXI_VERSION\", io=devnull)
   println(\"done\")
   print(\"Using Trixi... \")
   using_trixi = @elapsed using Trixi
   println(\"done\")
   println()
   @show add_trixi
   @show using_trixi
   open(\"$LOG_NAME\", \"a\") do f
     println(f, \"add_trixi = \", add_trixi)
     println(f, \"using_trixi = \", using_trixi)
   end
  "
set +x
