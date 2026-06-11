#!/bin/sh

set -e

. ./library_scripts.sh

ensure_nanolayer NANOLAYER_LOCATION "v0.5.6"

map_omp_asset_regex() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "omp-linux-x64$"
            ;;
        aarch64|arm64)
            echo "omp-linux-arm64$"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

ASSET_REGEX=$(map_omp_asset_regex)

"$NANOLAYER_LOCATION" \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.26" \
    --option repo='can1357/oh-my-pi' \
    --option binaryNames='omp' \
    --option assetRegex="$ASSET_REGEX" \
    --option version="$VERSION"
