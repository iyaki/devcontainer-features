#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'phpantom' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
check "phpantom_lsp installed" test -x /usr/local/bin/phpantom_lsp
check "phpantom_lsp on PATH" bash -c "command -v phpantom_lsp"
check "phpantom_lsp reports version" bash -c "phpantom_lsp --version"

# Report results
reportResults
