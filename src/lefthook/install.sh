#!/bin/sh
set -e

echo "Activating feature 'lefthook'"

VERSION=${VERSION:-latest}
INSTALL_DIR=${INSTALLDIR:-/usr/local/bin}

ensure_dependencies() {
    if command -v curl >/dev/null 2>&1 && command -v gzip >/dev/null 2>&1; then
        return 0
    fi

    if command -v apt-get >/dev/null 2>&1; then
        apt-get update -y
        apt-get install -y curl ca-certificates gzip
        rm -rf /var/lib/apt/lists/*
        return 0
    fi

    if command -v apk >/dev/null 2>&1; then
        apk add --no-cache curl ca-certificates gzip
        return 0
    fi

    echo "curl and gzip are required but could not be installed automatically." >&2
    exit 1
}

map_architecture() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

resolve_version_number() {
    if [ "$VERSION" = "latest" ]; then
        latest_tag=$(curl -fsSL "https://api.github.com/repos/evilmartians/lefthook/releases/latest" \
            | sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
            | head -n 1)

        if [ -z "$latest_tag" ]; then
            echo "Failed to resolve latest lefthook release version from GitHub API." >&2
            exit 1
        fi

        echo "${latest_tag#v}"
        return 0
    fi

    echo "${VERSION#v}"
}

ensure_dependencies

mkdir -p "$INSTALL_DIR"

ARCH=$(map_architecture)
VERSION_NUMBER=$(resolve_version_number)

GZ_URL="https://github.com/evilmartians/lefthook/releases/download/v${VERSION_NUMBER}/lefthook_${VERSION_NUMBER}_Linux_${ARCH}.gz"
BIN_URL="https://github.com/evilmartians/lefthook/releases/download/v${VERSION_NUMBER}/lefthook_${VERSION_NUMBER}_Linux_${ARCH}"

TMP_GZ=$(mktemp)
TMP_BIN=$(mktemp)

cleanup() {
    rm -f "$TMP_GZ" "$TMP_BIN"
}
trap cleanup EXIT

echo "Downloading lefthook ${VERSION_NUMBER} for Linux/${ARCH}"
if curl -fsSL -o "$TMP_GZ" "$GZ_URL"; then
    gzip -dc "$TMP_GZ" > "$TMP_BIN"
elif curl -fsSL -o "$TMP_BIN" "$BIN_URL"; then
    :
else
    echo "Failed to download lefthook from GitHub Releases for version ${VERSION_NUMBER} and architecture ${ARCH}." >&2
    exit 1
fi

install -m 0755 "$TMP_BIN" "$INSTALL_DIR/lefthook"
