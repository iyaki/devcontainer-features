#!/bin/bash

# This test file will be executed against the 'version_pinned' scenario in
# test/opencode-ralph/scenarios.json.

set -e

source dev-container-features-test-lib

check "ralph installed from pinned release" test -x /usr/local/bin/ralph
check "ralph on PATH" bash -c "command -v ralph"

reportResults
