#!/bin/sh

set -e

VERSION="${VERSION:-latest}"

# iyaki/enchiridion is a private repository: releases are read through the
# authenticated GitHub API. The token needs contents:read on that repo
# (fine-grained PAT); the github_token feature option is the documented
# source, GITHUB_TOKEN/ENCHIRIDION_TOKEN environment variables work too.
TOKEN="${GITHUB_TOKEN:-${ENCHIRIDION_TOKEN:-}}"
if [ -z "$TOKEN" ]; then
    echo "enchiridion feature requires a GitHub token with read access to the private repository iyaki/enchiridion." >&2
    echo 'Set the "github_token" option (e.g. "${localEnv:GITHUB_TOKEN}") or export GITHUB_TOKEN during the build.' >&2
    exit 1
fi

# Ensure a downloader exists up front: both the API calls and the asset
# download need one.
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

API_BASE="https://api.github.com/repos/iyaki/enchiridion"

api_get() {
    if type curl >/dev/null 2>&1; then
        curl -fsSL -H "Authorization: Bearer $TOKEN" "$1"
    else
        wget -q --header="Authorization: Bearer $TOKEN" -O - "$1"
    fi
}

download_asset() { # asset_id outfile
    if type curl >/dev/null 2>&1; then
        curl -fsSL -H "Authorization: Bearer $TOKEN" -H "Accept: application/octet-stream" \
            "$API_BASE/releases/assets/$1" -o "$2"
    else
        wget -q --header="Authorization: Bearer $TOKEN" --header="Accept: application/octet-stream" \
            -O "$2" "$API_BASE/releases/assets/$1"
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
    RELEASE_JSON=$(api_get "$API_BASE/releases/latest")
else
    RELEASE_JSON=$(api_get "$API_BASE/releases/tags/v$VERSION")
fi

TAG=$(printf '%s' "$RELEASE_JSON" | grep -oE '"tag_name": *"[^"]+"' | head -n 1 | sed 's/.*"tag_name": *"//; s/"$//')
if [ -z "$TAG" ]; then
    echo "Failed to resolve enchiridion release (version: $VERSION). Check that the token has read access to iyaki/enchiridion." >&2
    exit 1
fi
VERSION=$(printf '%s' "$TAG" | sed 's/^v//')

ASSET_NAME=$(map_enchiridion_asset_name "$VERSION")
# The asset's "id" field always precedes its "name" in the release JSON, so
# the nearest preceding id is the asset's own (nested uploader ids come
# after the name).
ASSET_ID=$(printf '%s' "$RELEASE_JSON" | tr ',' '\n' | sed 's/^ *//' | awk -v want="\"name\": \"$ASSET_NAME\"" '
    /"id": *[0-9]+/ { id = $0; sub(/.*"id": */, "", id); sub(/[^0-9].*/, "", id) }
    index($0, want) { print id; exit }
')
if [ -z "$ASSET_ID" ]; then
    echo "Asset $ASSET_NAME not found in release $TAG" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
download_asset "$ASSET_ID" "$tmp_dir/enchiridion.tar.gz"
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
