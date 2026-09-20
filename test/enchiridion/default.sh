#!/bin/bash

# This test file will be executed against the 'default' scenario in
# test/enchiridion/scenarios.json.

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "enchiridion installed" test -x /usr/local/bin/enchiridion
check "enchiridion on PATH" bash -c "command -v enchiridion"
check "version prints" bash -c "enchiridion version | grep -q 'enchiridion'"
# The real binary's config contract: without credentials it fails fast,
# names the missing variables, and never contacts the API.
check "sync fails fast without config" bash -c "! enchiridion sync" 
check "error names missing vars" bash -c "enchiridion sync 2>&1 | grep -q NOTION_TOKEN"

# Report results
reportResults
