#!/bin/bash

# This test file will be executed against the 'default' scenario in
# test/pie/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "pie installed" test -x /usr/local/bin/pie
check "pie on PATH" bash -c "command -v pie"
check "pie reports version" bash -c "pie --version"

# Report results
reportResults
