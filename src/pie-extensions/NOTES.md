# Notes

Installs PHP extensions using [PIE](https://github.com/php/pie) (PHP Installer for Extensions, the official PECL replacement) into the PHP installation provided by a PHP runtime feature.

## Pre-requisites

This Feature installs extensions into the system `php` binary found on PATH. It therefore requires:

- the **pie** Feature (`ghcr.io/iyaki/devcontainer-features/pie`) — provides the `pie` binary (declared via `installsAfter`);

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
