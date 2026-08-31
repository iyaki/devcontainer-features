#!/bin/bash

# This test file will be executed against the 'post_install' scenario in
# test/pie-extensions/scenarios.json.

set -e

source dev-container-features-test-lib

check "postInstall ran after install" test -f /tmp/pie-postinstall-ran
check "postInstall deleted extension file" bash -c '! test -f "$(php-config --extension-dir)/apcu.so"'
check "apcu no longer loaded" bash -c '! php -m | grep -q "^apcu$"'

# Report results
reportResults