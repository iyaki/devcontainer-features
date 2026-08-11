#!/bin/bash

# This test file will be executed against the 'default' scenario in
# test/pie-extensions/scenarios.json.

set -e

source dev-container-features-test-lib

check "php installed" bash -c "php --version"
check "pie installed" test -x /usr/local/bin/pie
check "pie on PATH" bash -c "command -v pie"
check "apcu extension installed" bash -c "php -m | grep -q '^apcu$'"
check "apcu extension loaded" bash -c "php -r 'var_dump(extension_loaded(\"apcu\"));' | grep -q true"
check "xdebug extension installed" bash -c "php -m | grep -q '^xdebug$'"
check "xdebug extension loaded" bash -c "php -r 'var_dump(extension_loaded(\"xdebug\"));' | grep -q true"

# Report results
reportResults
