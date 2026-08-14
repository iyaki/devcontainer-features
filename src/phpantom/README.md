
# PHPantom LSP (phpantom)

Installs PHPantom — a fast, lightweight PHP language server written in Rust — from the PHPantom-dev/phpantom_lsp GitHub Releases as a self-contained binary.

## Example Usage

```json
"features": {
    "ghcr.io/iyaki/devcontainer-features/phpantom:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | PHPantom release version to install (for example: 0.9.0). Use 'latest' for the newest release. Release tags are bare numbers (no 'v' prefix). | string | latest |

# Notes

Installs PHPantom — a fast, lightweight PHP language server written in Rust — from GitHub Releases as a self-contained binary bundled with phpstorm-stubs, so it needs no PHP runtime. Supports `x86_64` and `arm64` Linux architectures.

The `version` option accepts a bare release number such as `0.9.0` (PHPantom tags have no `v` prefix). Use `latest` for the newest release.

Additional resources:

- [PHPantom GitHub Repository](https://github.com/PHPantom-dev/phpantom_lsp)
- [PHPantom documentation](https://phpantom-dev.github.io/phpantom_lsp/)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/iyaki/devcontainer-features/blob/main/src/phpantom/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
