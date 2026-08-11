#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'pie' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
check "pie installed" test -x /usr/local/bin/pie
check "pie on PATH" bash -c "command -v pie"
check "pie reports version" bash -c "pie --version"

# Report results
reportResults
