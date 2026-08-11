#!/bin/sh

set -e

# Installs PHP extensions using PIE (PHP Installer for Extensions) into the PHP
# installation provided by a PHP runtime feature.
#
# Requires (declared via installsAfter so they are present when this runs):
#  - the 'pie' feature: provides the `pie` binary on PATH
#  - a PHP runtime with build tools, e.g. the official PHP devcontainer feature
#    (provides `php`, `phpize`, `php-config`, autoconf, make, gcc, git)
#
# PIE installs extensions into the system `php` binary found on PATH, so it must
# run as root (devcontainer features run as root by default).

if ! command -v pie >/dev/null 2>&1; then
    echo "pie binary not found on PATH. Add the 'pie' feature (ghcr.io/iyaki/devcontainer-features/pie) to your devcontainer.json." >&2
    exit 1
fi

if ! command -v php >/dev/null 2>&1; then
    echo "php binary not found on PATH. Add a PHP runtime with build tools, e.g. ghcr.io/devcontainers/features/php, to your devcontainer.json." >&2
    exit 1
fi

# The official PHP feature sets the PHP_PATH env var to the PHP install
# DIRECTORY, but Symfony's PhpExecutableFinder (which PIE uses to locate the
# target PHP) treats PHP_PATH as a path to a binary and bails on directories
# with "Could not find path to PHP executable." Point it at the real binary.
export PHP_PATH="$(command -v php)"

# The official PHP feature installs PHP to /usr/local/php/current/bin and adds
# it to PATH via shell rc files, which are not sourced during a build — expose
# the bin dir so PIE can find the target PHP. Harmless no-op for other layouts.
if [ -d /usr/local/php/current/bin ]; then
    export PATH="/usr/local/php/current/bin:$PATH"
fi

# EXTENSIONS: comma-separated list of PIE packages (Composer-style vendor/package
# names), e.g. "apcu/apcu,xdebug/xdebug". Per-package version constraints are
# supported, e.g. "xdebug/xdebug:^3.4".
if [ -z "${EXTENSIONS:-}" ]; then
    echo "No extensions specified. Set the 'extensions' option, e.g. \"extensions\": \"apcu/apcu,xdebug/xdebug\"." >&2
    exit 1
fi

# ponytail: IFS split on comma and space keeps the loop to one line; empty
# entries (double commas / stray spaces) are skipped by the -z guard.
# pie install accepts ONE package per invocation (multi-package is PIE 1.5+),
# so each extension is installed in its own call.
IFS=', '
for pkg in $EXTENSIONS; do
    [ -z "$pkg" ] && continue
    echo "Installing $pkg via PIE..."
    pie install \
        --no-cache \
        --auto-install-build-tools \
        --auto-install-system-dependencies \
        "$pkg"
done
