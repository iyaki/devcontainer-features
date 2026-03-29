#!/bin/bash

# This test file will be executed against the 'default' scenario in
# test/ralph/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "ralph installed" test -x /usr/local/bin/ralph
check "ralph on PATH" bash -c "command -v ralph"

# Report results
reportResults
