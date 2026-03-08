#!/bin/sh
set -e

echo "Activating feature 'lefthook'"

VERSION=${VERSION:-latest}
INSTALL_DIR=${INSTALLDIR:-/usr/local/bin}
NANOLAYER_VERSION="v0.5.6"
NANOLAYER_LOCATION=""

ensure_dependencies() {
    if command -v curl >/dev/null 2>&1 && command -v tar >/dev/null 2>&1 && command -v gzip >/dev/null 2>&1; then
        return 0
    fi

    if command -v apt-get >/dev/null 2>&1; then
        apt-get update -y
        apt-get install -y curl ca-certificates tar gzip
        rm -rf /var/lib/apt/lists/*
        return 0
    fi

    if command -v apk >/dev/null 2>&1; then
        apk add --no-cache curl ca-certificates tar gzip
        return 0
    fi

    echo "curl, tar, and gzip are required but could not be installed automatically." >&2
    exit 1
}

map_nanolayer_architecture() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

map_lefthook_asset_regex() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo ".*_Linux_x86_64$"
            ;;
        aarch64|arm64)
            echo ".*_Linux_(arm64|aarch64)$"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

ensure_nanolayer() {
    if command -v nanolayer >/dev/null 2>&1; then
        NANOLAYER_LOCATION="nanolayer"
        return 0
    fi

    arch=$(map_nanolayer_architecture)
    if command -v apk >/dev/null 2>&1; then
        clib_type="musl"
    else
        clib_type="gnu"
    fi

    tar_filename="nanolayer-${arch}-unknown-linux-${clib_type}.tgz"
    tmp_dir=$(mktemp -d)

    cleanup() {
        if [ -n "$tmp_dir" ] && [ -d "$tmp_dir" ]; then
            rm -rf "$tmp_dir"
        fi
    }
    trap cleanup EXIT

    curl -fsSL -o "$tmp_dir/$tar_filename" "https://github.com/devcontainers-extra/nanolayer/releases/download/${NANOLAYER_VERSION}/${tar_filename}"
    tar xfz "$tmp_dir/$tar_filename" -C "$tmp_dir"
    chmod +x "$tmp_dir/nanolayer"
    NANOLAYER_LOCATION="$tmp_dir/nanolayer"
}

ensure_dependencies
mkdir -p "$INSTALL_DIR"
ensure_nanolayer
ASSET_REGEX=$(map_lefthook_asset_regex)

echo "Installing lefthook ${VERSION} using nanolayer"
"$NANOLAYER_LOCATION" \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.26" \
    --option repo='evilmartians/lefthook' \
    --option binaryNames='lefthook' \
    --option version="$VERSION" \
    --option binLocation="$INSTALL_DIR" \
    --option assetRegex="$ASSET_REGEX"
