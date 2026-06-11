#!/bin/bash

set -e

source dev-container-features-test-lib

check "omp installed" test -x /usr/local/bin/omp
check "omp on PATH" bash -c "command -v omp"

reportResults
