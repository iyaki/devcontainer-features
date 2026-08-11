
# PHP Installer for Extensions (PIE) (pie)

Installs PIE — the official PHP extension installer (replaces PECL) — from the php/pie GitHub Releases as a self-contained static binary.

## Example Usage

```json
"features": {
    "ghcr.io/iyaki/devcontainer-features/pie:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | PIE release version to install (for example: 1.4.9). Use 'latest' for the newest release. Release tags are bare numbers (no 'v' prefix). | string | latest |

# Notes

Installs PIE from GitHub Releases as a self-contained static binary (`pie-Linux-X64` / `pie-Linux-ARM64`) so that PIE itself runs without a PHP runtime. Supports `x86_64` and `arm64` Linux architectures.

PIE installs PHP extensions into a PHP installation, so a PHP runtime (e.g. installed via `ghcr.io/devcontainers/features/php`) is required to actually build or install extensions. This Feature declares `installsAfter` the official PHP feature so that, when composed together, PHP is present before PIE runs.

The `version` option accepts a bare release number such as `1.4.9` (PIE tags have no `v` prefix). Use `latest` for the newest release.

Additional resources:

- [PIE GitHub Repository](https://github.com/php/pie)
- [PIE documentation](https://php.github.io/pie/)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/iyaki/devcontainer-features/blob/main/src/pie/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
