# Trixi performance tests with Julia 1.7 vs. 1.8

A collection of scripts for semi-automated performance tests to compare
different Julia versions for running a
[Trixi.jl](https://github.com/trixi-framework/Trixi.jl) simulation, including timings
for loading the relevant packages Trixi.jl and
[OrdinaryDiffEq.jl](https://github.com/SciML/OrdinaryDiffEq.jl).

The scripts in this repository are written such that they need to be executed
from the working directory in which the tests are to be run. For example, if you
want to run tests with Julia 1.7 and 1.8, you could create two folders
`julia-1.7` and `julia-1.8`, `cd` into each directory and then run the scripts
from there as, e.g., `../ttfx.jl julia`.

Unless noted otherwise, in the following all commands assume that you are
already inside a test directory. Further, we assume that your Julia 1.7 and 1.8
executables are available as `julia-1.7` and `julia-1.8` respectively.


## Setting up the package installations
There are two ways to install all required packages: Either by installing from scratch
using `setup.sh`, or by insantiating the `Project.toml` and `Manifest.toml`
files found in this repo using `instantiate.sh`.

### Installing from scratch
Running
```bash
../setup.sh julia-1.8
```
will install OrdinaryDiffEq.jl v6.24.0 and Trixi.jl v0.4.44, each of which is
the current version (as of 2022-08-23).
The first argument `julia-1.8` is the `which`-expanded Julia executable that
will be used.

### Instantiating from existing Project.toml/Manifest.toml
First, copy [Project.toml](Project.toml) and the relevant `Manifest.toml` file
from this repo into the test folder. Then, run
```bash
../instantiate.sh julia-1.8
```
to instantiate.
The first argument `julia-1.8` is the `which`-expanded Julia executable that
will be used.


## Run performance tests for package loading
Execute
```bash
../using.sh julia-1.8
```
to get timings for loading OrdinaryDiffEq.jl and Trixi.jl. Two
checks are performed, once with OrdinaryDiffEq.jl loaded first and Trixi.jl
second, once vice-versa.
The first argument `julia-1.8` is the `which`-expanded Julia executable that
will be used.


## Run performance tests on execution
Execute
```bash
../ttfx.sh julia-1.8 --check-bounds=no
```
to get timings for running a Trixi simulation. By default, it will use the
[`elixir_euler_source_terms_nonperiodic_modified.jl`](elixir_euler_source_terms_nonperiodic_modified.jl)
elixir found in this repository.
The first argument `julia-1.8` is the `which`-expanded Julia executable that
will be used. The second and subsequent arguments will be passed to the Julia
executable, e.g., to disable bounds checking.

There is also a script `runall.sh` that is to be run *from the repo root
folder*. It needs to be edited manually, but allows to run multiple trials in a loop.


## Authors
This repository was initiated by [Michael
Schlottke-Lakemper](https://www.hlrs.de/people/schlottke-lakemper), with input
from the [Trixi.jl authors](https://github.com/trixi-framework/Trixi.jl/blob/main/AUTHORS.md).

## License
This repository and its contents are published under the MIT license (see
[LICENSE.md](LICENSE.md)).
