#!/bin/sh
set -e

echo "Activating feature 'opencode-ralph'"

VERSION=${VERSION:-latest}
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

resolve_version() {
	if [ "$VERSION" = "latest" ]; then
		echo "Resolving latest release version..." >&2
		VERSION=$(curl -fsSL "https://api.github.com/repos/iyaki/ralph/releases/latest" \
			| grep '"tag_name"' \
			| sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')
		if [ -z "$VERSION" ]; then
			echo "Failed to resolve latest release version." >&2
			exit 1
		fi
		echo "Resolved latest version: $VERSION" >&2
	fi
}

resolve_version


EXECUTABLE_NAME="ralph.sh"
case "$VERSION" in
	latest)
		RALPH_URL="https://github.com/iyaki/ralph/releases/latest/download/$EXECUTABLE_NAME"
		;;
	v[0-9]*)
		RALPH_URL="https://github.com/iyaki/ralph/releases/download/${VERSION}/$EXECUTABLE_NAME"
		;;
	*)
		echo "Unsupported version '$VERSION'. Use 'latest' or a release tag such as 'v1.0.1'." >&2
		exit 1
		;;
esac

TMP_FILE=$(mktemp)

echo "Downloading ralph script from $RALPH_URL"
curl -fsSL -o "$TMP_FILE" "$RALPH_URL"

install -m 0755 "$TMP_FILE" "$INSTALL_DIR/ralph"
rm -f "$TMP_FILE"
