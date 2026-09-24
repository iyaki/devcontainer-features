#!/bin/bash

set -e

source dev-container-features-test-lib

check "enchiridion installed" test -x /usr/local/bin/enchiridion
check "enchiridion version runs" bash -c "enchiridion version"

reportResults
