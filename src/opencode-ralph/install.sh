#!/bin/sh

set -e

. ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer NANOLAYER_LOCATION "v0.5.6"

# Feature options are surfaced as env vars by devcontainer CLI (e.g. installDir -> INSTALLDIR).
# Keep backward compatibility with INSTALL_DIR if set by callers.
INSTALL_DIR="${INSTALLDIR:-${INSTALL_DIR:-/usr/local/bin}}"

# map_ralph_asset_regex() {
#     case "$(uname -m)" in
#         x86_64|amd64)
#             echo "ralph_.*_linux_amd64$"
#             ;;
#         aarch64|arm64)
#             echo "ralph_.*_linux_arm64$"
#             ;;
#         *)
#             echo "Unsupported architecture: $(uname -m)" >&2
#             exit 1
#             ;;
#     esac
# }


mkdir -p "$INSTALL_DIR"
# ASSET_REGEX=$(map_ralph_asset_regex)

echo "Installing ralph ${VERSION} using nanolayer"
"$NANOLAYER_LOCATION" \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.26" \
    --option repo='iyaki/ralph' \
    --option binaryNames='ralph' \
    --option version="$VERSION" \
    --option binLocation="$INSTALL_DIR"
    # --option assetRegex="$ASSET_REGEX"
