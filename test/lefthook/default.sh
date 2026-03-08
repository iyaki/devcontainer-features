#!/bin/bash

# This test file will be executed against the 'default' scenario in
# test/lefthook/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "lefthook installed" test -x /usr/local/bin/lefthook
check "lefthook on PATH" bash -c "command -v lefthook"

# Report results
reportResults
