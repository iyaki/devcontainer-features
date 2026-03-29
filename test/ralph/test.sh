#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'ralph' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
check "ralph installed" test -x /usr/local/bin/ralph
check "ralph on PATH" bash -c "command -v ralph"

# Report results
reportResults
