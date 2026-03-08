#!/bin/bash

# This test file will be executed against the 'install_dir_custom' scenario in
# test/lefthook/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "lefthook installed in custom dir" test -x /opt/lefthook/bin/lefthook

# Report results
reportResults
