#!/bin/sh

set -e

. ./library_scripts.sh

VERSION="${VERSION:-latest}"

map_lefthook_asset_suffix() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "Linux_x86_64"
            ;;
        aarch64)
            echo "Linux_aarch64"
            ;;
        arm64)
            echo "Linux_arm64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

resolve_latest_tag() {
    # Resolve "latest" without the GitHub API (which rate-limits
    # unauthenticated requests): the releases/latest page redirects to the
    # tagged release, and the tag is embedded in the page HTML.
    tmp_file=$(mktemp)
    clean_download "https://github.com/evilmartians/lefthook/releases/latest" "$tmp_file"
    tag=$(grep -oE 'releases/tag/v[0-9]+\.[0-9]+\.[0-9]+' "$tmp_file" | head -n 1 | sed 's#releases/tag/##')
    rm -f "$tmp_file"
    if [ -z "$tag" ]; then
        echo "Failed to resolve latest lefthook release tag" >&2
        exit 1
    fi
    echo "$tag"
}

# Normalize to a bare version (no leading "v")
VERSION=$(printf '%s' "$VERSION" | sed 's/^v//')

if [ "$VERSION" = "latest" ]; then
    TAG=$(resolve_latest_tag)
    VERSION=$(printf '%s' "$TAG" | sed 's/^v//')
else
    TAG="v$VERSION"
fi

ASSET_SUFFIX=$(map_lefthook_asset_suffix)
URL="https://github.com/evilmartians/lefthook/releases/download/${TAG}/lefthook_${VERSION}_${ASSET_SUFFIX}"

tmp_bin=$(mktemp)
clean_download "$URL" "$tmp_bin"
install -m 0755 "$tmp_bin" /usr/local/bin/lefthook
rm -f "$tmp_bin"

lefthook version
