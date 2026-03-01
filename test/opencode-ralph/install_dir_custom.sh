#!/bin/bash

# This test file will be executed against the 'install_dir_custom' scenario in
# test/opencode-ralph/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "ralph installed in custom dir" test -x /opt/ralph/bin/ralph

# Report results
reportResults
