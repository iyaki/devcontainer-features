#!/bin/sh

set -e

VERSION="${VERSION:-latest}"

REPO_BASE="https://github.com/iyaki/enchiridion"

# Ensure a downloader exists up front: release discovery and the asset
# download both need one.
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

download() { # url outfile
    if type curl >/dev/null 2>&1; then
        curl -fsSL "$1" -o "$2"
    else
        wget -q -O "$2" "$1"
    fi
}

# Latest tag via the /releases/latest redirect: no API call, so no GitHub
# API rate limit on shared CI runners.
resolve_latest_tag() {
    if type curl >/dev/null 2>&1; then
        curl -fsSL -o /dev/null -w '%{url_effective}\n' "$REPO_BASE/releases/latest" \
            | sed 's|.*/tag/||; s/[[:space:]]*$//'
    else
        wget -q --max-redirect=0 -S -O /dev/null "$REPO_BASE/releases/latest" 2>&1 \
            | tr -d '\r' | grep -i '^ *Location:' | head -n 1 | sed 's|.*/tag/||; s/[[:space:]]*$//'
    fi
}

map_enchiridion_asset_name() { # version without leading "v"
    case "$(uname -m)" in
        x86_64|amd64)
            echo "enchiridion_$1_linux_amd64.tar.gz"
            ;;
        aarch64|arm64)
            echo "enchiridion_$1_linux_arm64.tar.gz"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
}

VERSION=$(printf '%s' "$VERSION" | sed 's/^v//')

if [ "$VERSION" = "latest" ]; then
    TAG=$(resolve_latest_tag)
else
    TAG="v$VERSION"
fi
if [ -z "$TAG" ]; then
    echo "Failed to resolve enchiridion release (version: $VERSION). Check the version and that $REPO_BASE is reachable." >&2
    exit 1
fi

ASSET_NAME=$(map_enchiridion_asset_name "${TAG#v}")
ASSET_URL="$REPO_BASE/releases/download/$TAG/$ASSET_NAME"

tmp_dir=$(mktemp -d)
download "$ASSET_URL" "$tmp_dir/enchiridion.tar.gz"
tar -xzf "$tmp_dir/enchiridion.tar.gz" -C "$tmp_dir"
install -m 0755 "$tmp_dir/enchiridion" /usr/local/bin/enchiridion
rm -rf "$tmp_dir"

# The enchiridion_home option is specced (integration.md — Distribution).
# Feature containerEnv cannot interpolate options, so persist the choice for
# login shells; consumers needing it in non-login tooling set
# ENCHIRIDION_HOME in their own containerEnv/remoteEnv.
if [ -n "${ENCHIRIDION_HOME:-}" ]; then
    echo "enchiridion cache root: $ENCHIRIDION_HOME"
    printf 'export ENCHIRIDION_HOME="%s"\n' "$ENCHIRIDION_HOME" \
        > /etc/profile.d/enchiridion.sh
fi

enchiridion version
