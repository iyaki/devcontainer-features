#!/bin/bash

# This test file will be executed against the 'version_pinned' scenario in
# test/phpantom/scenarios.json.

set -e

source dev-container-features-test-lib

check "phpantom_lsp installed from pinned release" test -x /usr/local/bin/phpantom_lsp
check "phpantom_lsp on PATH" bash -c "command -v phpantom_lsp"
check "phpantom_lsp reports pinned version" bash -c "phpantom_lsp --version | grep '0\.9\.0'"

# Report results
reportResults
