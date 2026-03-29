#!/bin/sh

set -e

. ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer NANOLAYER_LOCATION "v0.5.6"

map_lefthook_asset_regex() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo ".*_Linux_x86_64$"
            ;;
        aarch64)
            echo ".*_Linux_aarch64$"
            ;;
        arm64)
            echo ".*_Linux_arm64$"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

ASSET_REGEX=$(map_lefthook_asset_regex)

"$NANOLAYER_LOCATION" \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.26" \
    --option repo='evilmartians/lefthook' \
    --option binaryNames='lefthook' \
    --option assetRegex="$ASSET_REGEX" \
    --option version="$VERSION"
