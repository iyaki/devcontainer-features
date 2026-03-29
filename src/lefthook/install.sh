#!/bin/sh

set -e

. ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer NANOLAYER_LOCATION "v0.5.6"

"$NANOLAYER_LOCATION" \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.26" \
    --option repo='evilmartians/lefthook' \
    --option binaryNames='lefthook' \
    --option version="$VERSION"
