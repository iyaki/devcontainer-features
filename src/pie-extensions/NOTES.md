# Notes

Installs PHP extensions using [PIE](https://github.com/php/pie) (PHP Installer for Extensions, the official PECL replacement) into the PHP installation provided by a PHP runtime feature.

## Pre-requisites

This Feature installs extensions into the system `php` binary found on PATH. It requires:

- A **PHP runtime with build tools** — `php`, `phpize`, `php-config`, `autoconf`, `make`, `gcc`, and `git` (PIE needs these to download, build, and install extensions). This is a pre-requisite, not declared via `installsAfter`: feature install order is not guaranteed, so PHP must already be present when this Feature installs — e.g. use a PHP base image like `mcr.microsoft.com/devcontainers/php:8.4`.
- The **pie** Feature (`ghcr.io/iyaki/devcontainer-features/pie`) — installed via `dependsOn` in `devcontainer-feature.json`, so it will be installed automatically if not already present.

Example:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/php:8.4",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/pie-extensions": {
            "extensions": "apcu/apcu,xdebug/xdebug"
        }
    }
}
```

## Options

The `extensions` option takes a comma-separated list of PIE packages (Composer-style `vendor/package` names, e.g. `apcu/apcu`). Per-package version constraints are supported, e.g. `xdebug/xdebug:^3.4`.

Each package is installed with `pie install --no-cache --auto-install-build-tools --auto-install-system-dependencies` so the build runs non-interactively in a container (no prompts for missing build tools or system libraries).

A list of PIE-compatible packages is available at <https://packagist.org/extensions>.

## Post-install commands

The optional `postInstall` option takes a multi-line bash script that runs once, as root, after all extensions are installed. Use it to edit or delete files created during installation, e.g. removing a shared object PIE installed:

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/php:8.4",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/pie-extensions": {
            "extensions": "apcu/apcu",
            "postInstall": "rm -f $(php-config --extension-dir)/apcu.so"
        }
    }
}
```

A non-zero exit code of the script fails the build.

## Design notes

- The official PHP feature sets the `PHP_PATH` env var to the PHP install *directory* (`/usr/local/php/current`). PIE locates the target PHP via Symfony's `PhpExecutableFinder`, which treats `PHP_PATH` as a path to a *binary* and bails on directories (`Could not find path to PHP executable`). The install script therefore exports `PHP_PATH="$(command -v php)"` before invoking `pie`.
