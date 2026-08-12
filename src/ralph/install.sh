#!/bin/sh

set -e

. ./library_scripts.sh

VERSION="${VERSION:-latest}"

# Normalize to a bare version (no leading "v")
VERSION=$(printf '%s' "$VERSION" | sed 's/^v//')

resolve_latest_tag() {
    # Resolve "latest" without the GitHub API (which rate-limits
    # unauthenticated requests): the releases/latest page redirects to the
    # tagged release, and the tag is embedded in the page HTML.
    tmp_file=$(mktemp)
    clean_download "https://github.com/iyaki/specralph/releases/latest" "$tmp_file"
    tag=$(grep -oE 'releases/tag/v?[0-9]+\.[0-9]+\.[0-9]+' "$tmp_file" | head -n 1 | sed 's#releases/tag/##')
    rm -f "$tmp_file"
    if [ -z "$tag" ]; then
        echo "Failed to resolve latest specralph release tag" >&2
        exit 1
    fi
    echo "$tag"
}

if [ "$VERSION" = "latest" ]; then
    TAG=$(resolve_latest_tag)
    VERSION=$(printf '%s' "$TAG" | sed 's/^v//')
else
    TAG="v$VERSION"
fi

map_ralph_asset_name() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "ralph_v${VERSION}_linux_amd64"
            ;;
        aarch64|arm64)
            echo "ralph_v${VERSION}_linux_arm64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

ASSET_NAME=$(map_ralph_asset_name)
URL="https://github.com/iyaki/specralph/releases/download/${TAG}/${ASSET_NAME}"

tmp_bin=$(mktemp)
clean_download "$URL" "$tmp_bin"
install -m 0755 "$tmp_bin" /usr/local/bin/ralph
rm -f "$tmp_bin"
