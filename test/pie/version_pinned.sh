#!/bin/bash

# This test file will be executed against the 'version_pinned' scenario in
# test/pie/scenarios.json.

set -e

source dev-container-features-test-lib

check "pie installed from pinned release" test -x /usr/local/bin/pie
check "pie on PATH" bash -c "command -v pie"
check "pie reports pinned version" bash -c "pie --version | grep '1\.4\.9'"

# Report results
reportResults
