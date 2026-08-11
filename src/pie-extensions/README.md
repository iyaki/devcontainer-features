
# PHP Extensions via PIE (pie-extensions)

Installs PHP extensions using PIE (PHP Installer for Extensions) into the PHP installation provided by a PHP runtime feature. Requires the pie feature and a PHP runtime with build tools, e.g. the official PHP devcontainer feature.

## Example Usage

```json
"features": {
    "ghcr.io/iyaki/devcontainer-features/pie-extensions:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| extensions | Comma-separated list of PIE packages to install, e.g. "apcu/apcu,xdebug/xdebug". PIE package names are Composer-style vendor/package names; per-package version constraints are supported, e.g. "xdebug/xdebug:^3.4". | string | - |

# Notes

Installs PHP extensions using [PIE](https://github.com/php/pie) (PHP Installer for Extensions, the official PECL replacement) into the PHP installation provided by a PHP runtime feature.

## Pre-requisites

This Feature installs extensions into the system `php` binary found on PATH. It therefore requires:

- the **pie** Feature (`ghcr.io/iyaki/devcontainer-features/pie`) — provides the `pie` binary (declared via `installsAfter`);
- a **PHP runtime with build tools** — e.g. the official [`ghcr.io/devcontainers/features/php`](https://github.com/devcontainers/features/tree/main/src/php) feature, which compiles PHP from source and ships `phpize`, `php-config`, `autoconf`, `make`, `gcc`, and `git`. PIE needs these to download, build, and install extensions.

The PHP runtime is **not** declared via `installsAfter`, so it will not be pulled in automatically: you must include it yourself in `devcontainer.json` (any order works as long as it is present when this Feature installs).

Example:

```jsonc
"features": {
    "ghcr.io/devcontainers/features/php": { "version": "8.4" },
    "ghcr.io/iyaki/devcontainer-features/pie": {},
    "ghcr.io/iyaki/devcontainer-features/pie-extensions": {
        "extensions": "apcu/apcu,xdebug/xdebug"
    }
}
```

## Options

The `extensions` option takes a comma-separated list of PIE packages (Composer-style `vendor/package` names, e.g. `apcu/apcu`). Per-package version constraints are supported, e.g. `xdebug/xdebug:^3.4`.

Each package is installed with `pie install --no-cache --auto-install-build-tools --auto-install-system-dependencies` so the build runs non-interactively in a container (no prompts for missing build tools or system libraries).

A list of PIE-compatible packages is available at <https://packagist.org/extensions>.

## Design notes

- The official PHP feature sets the `PHP_PATH` env var to the PHP install *directory* (`/usr/local/php/current`). PIE locates the target PHP via Symfony's `PhpExecutableFinder`, which treats `PHP_PATH` as a path to a *binary* and bails on directories (`Could not find path to PHP executable`). The install script therefore exports `PHP_PATH="$(command -v php)"` before invoking `pie`.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/iyaki/devcontainer-features/blob/main/src/pie-extensions/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
