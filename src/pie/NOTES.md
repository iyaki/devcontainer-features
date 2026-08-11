# Notes

Installs PIE (PHP Installer for Extensions) from GitHub Releases as a self-contained static binary (`pie-Linux-X64` / `pie-Linux-ARM64`) so that PIE itself runs without a PHP runtime. Supports `x86_64` and `arm64` Linux architectures.

PIE installs PHP extensions into a PHP installation, so a PHP runtime (e.g. installed via `ghcr.io/devcontainers/features/php`) is required to actually build or install extensions.

The `version` option accepts a bare release number such as `1.4.9` (PIE tags have no `v` prefix). Use `latest` for the newest release.

Additional resources:

- [PIE GitHub Repository](https://github.com/php/pie)
- [PIE documentation](https://php.github.io/pie/)
