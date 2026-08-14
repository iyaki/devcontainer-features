#!/bin/bash

# This test file will be executed against the 'default' scenario in
# test/phpantom/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "phpantom_lsp installed" test -x /usr/local/bin/phpantom_lsp
check "phpantom_lsp on PATH" bash -c "command -v phpantom_lsp"
check "phpantom_lsp reports version" bash -c "phpantom_lsp --version"

# Report results
reportResults
