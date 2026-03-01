#!/bin/sh
set -e

echo "Activating feature 'opencode-ralph'"

VERSION=${VERSION:-main}
INSTALL_DIR=${INSTALLDIR:-/usr/local/bin}

ensure_curl() {
	if command -v curl >/dev/null 2>&1; then
		return 0
	fi

	if command -v apt-get >/dev/null 2>&1; then
		apt-get update -y
		apt-get install -y curl ca-certificates
		rm -rf /var/lib/apt/lists/*
		return 0
	fi

	if command -v apk >/dev/null 2>&1; then
		apk add --no-cache curl ca-certificates
		return 0
	fi

	echo "curl is required but could not be installed automatically." >&2
	exit 1
}

ensure_curl

mkdir -p "$INSTALL_DIR"

RALPH_URL="https://raw.githubusercontent.com/iyaki/ralph/${VERSION}/ralph.sh"
TMP_FILE=$(mktemp)

echo "Downloading ralph script from $RALPH_URL"
curl -fsSL -o "$TMP_FILE" "$RALPH_URL"

install -m 0755 "$TMP_FILE" "$INSTALL_DIR/ralph"
rm -f "$TMP_FILE"
