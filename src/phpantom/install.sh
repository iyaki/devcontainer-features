#!/bin/sh

set -e

. ./library_scripts.sh

VERSION="${VERSION:-latest}"

# Ensure a downloader exists up front so clean_download never has to install
# and purge wget per call: each apt cycle is slow (and has flaked in CI), and
# both the tag resolution and the asset download would otherwise trigger one.
if ! type curl >/dev/null 2>&1 && ! type wget >/dev/null 2>&1; then
    if [ -x /usr/bin/apt-get ]; then
        apt-get update -y
        apt-get install -y --no-install-recommends wget ca-certificates
    elif [ -x /sbin/apk ]; then
        apk add --no-cache wget
    else
        echo "No downloader available and no supported package manager" >&2
        exit 1
    fi
fi

map_phpantom_asset_name() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "phpantom_lsp-x86_64-unknown-linux-gnu"
            ;;
        aarch64|arm64)
            echo "phpantom_lsp-aarch64-unknown-linux-gnu"
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
    clean_download "https://github.com/PHPantom-dev/phpantom_lsp/releases/latest" "$tmp_file"
    tag=$(grep -oE 'releases/tag/v?[0-9]+\.[0-9]+\.[0-9]+' "$tmp_file" | head -n 1 | sed 's#releases/tag/##')
    rm -f "$tmp_file"
    if [ -z "$tag" ]; then
        echo "Failed to resolve latest phpantom release tag" >&2
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
    # phpantom release tags are bare version numbers (no "v" prefix)
    TAG="$VERSION"
fi

ASSET_NAME=$(map_phpantom_asset_name)
URL="https://github.com/PHPantom-dev/phpantom_lsp/releases/download/${TAG}/${ASSET_NAME}.tar.gz"

tmp_tar=$(mktemp)
tmp_dir=$(mktemp -d)
clean_download "$URL" "$tmp_tar"
tar xzf "$tmp_tar" -C "$tmp_dir"
install -m 0755 "$tmp_dir/phpantom_lsp" /usr/local/bin/phpantom_lsp
rm -rf "$tmp_dir" "$tmp_tar"

phpantom_lsp --version
