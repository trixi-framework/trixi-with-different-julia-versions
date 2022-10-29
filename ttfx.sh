#!/bin/bash

LOG_NAME=results.txt

set -eo pipefail

if [ $# -lt 1 ]; then
  echo "ERROR: missing argument: Julia executable" >&2
  exit 2
fi
JULIA_EXECUTABLE="$(which $1 || true)"
if [ -z "$JULIA_EXECUTABLE" ]; then
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
echo "JULIA ARGS:       " $@

echo
echo "################################################################################"
echo "Running Time-To-First-X tests..."
echo "################################################################################"
set -x
JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. $@ -e \
  "
   println(\"\n\nusing OrdinaryDiffEq.jl...\")
   elapsed_using_ordinarydiffeq = @elapsed using OrdinaryDiffEq
   println(\"\n\nusing Trixi.jl...\")
   elapsed_using_trixi = @elapsed using Trixi
   println(\"\n\nRun Trixi.jl #1...\")
   elapsed_trixi_1 = @elapsed trixi_include(\"../elixir_euler_source_terms_nonperiodic_modified.jl\")
   println(\"\n\nRun Trixi.jl #2...\")
   elapsed_trixi_2 = @elapsed trixi_include(\"../elixir_euler_source_terms_nonperiodic_modified.jl\")
   println(\"\n\nTiming results:\")
   @show elapsed_using_ordinarydiffeq
   @show elapsed_using_trixi
   @show elapsed_trixi_1
   @show elapsed_trixi_2
   open(\"$LOG_NAME\", \"a\") do f
     println(f, \"=\"^80)
     println(f, \"elapsed_using_ordinarydiffeq = \", elapsed_using_ordinarydiffeq)
     println(f, \"elapsed_using_trixi = \", elapsed_using_trixi)
     println(f, \"elapsed_trixi_1 = \", elapsed_trixi_1)
     println(f, \"elapsed_trixi_2 = \", elapsed_trixi_2)
   end
  "

# JULIA_DEPOT_PATH=$DEPOT_PATH $JULIA_EXECUTABLE --project=. -e \
#   '
#    println("\n\nusing OrdinaryDiffEq.jl...")
#    elapsed_using_ordinarydiffeq = @elapsed using OrdinaryDiffEq
#    println("\n\nusing Trixi.jl...")
#    elapsed_using_trixi = @elapsed using Trixi
#    println("\n\nRun Trixi.jl #1...")
#    elapsed_trixi_1 = @elapsed trixi_include(default_example());
#    println("\n\nRun Trixi.jl #2...")
#    elapsed_trixi_2 = @elapsed trixi_include(default_example());
#    println("\n\nTiming results:")
#    @show elapsed_using_ordinarydiffeq
#    @show elapsed_using_trixi
#    @show elapsed_trixi_1
#    @show elapsed_trixi_2
#   '
