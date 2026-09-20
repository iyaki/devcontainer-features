#!/bin/bash

# This test file will be executed against the 'pinned' scenario in
# test/enchiridion/scenarios.json: an explicit release version.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "pinned binary installed" test -x /usr/local/bin/enchiridion
check "pinned version reported" bash -c "enchiridion version | grep -qx 'enchiridion 0.1.0'"

# Report results
reportResults
