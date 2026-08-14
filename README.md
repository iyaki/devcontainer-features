# Dev Container Features

This repository contains a collection of dev container Features for use with [Dev Containers](https://containers.dev/).

## Features

This repository contains the following Features:

- [**ralph**](#ralph) - AI Agentic Loop shell runner for spec-driven development workflows
- [**lefthook**](#lefthook) - Git hooks manager for fast and powerful Git hook workflows
- [**oh-my-pi**](#oh-my-pi) - AI coding agent toolkit for terminal-based development
- [**pie**](#pie) - PHP Installer for Extensions (PIE), the official PECL replacement, as a self-contained static binary
- [**pie-extensions**](#pie-extensions) - Installs PHP extensions using PIE into a PHP installation
- [**phpantom**](#phpantom) - PHPantom, a fast and lightweight PHP language server written in Rust, as a self-contained binary

### `oh-my-pi`

Installs `omp` (Oh My Pi) from [can1357/oh-my-pi](https://github.com/can1357/oh-my-pi) GitHub Releases — an AI coding agent toolkit for terminal-based development.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/oh-my-pi:": {
            "version": "latest"
        }
    }
}
```

```bash
$ omp --help

# OMP installed and ready to use
```

Each sub-section below shows a sample `devcontainer.json` alongside example usage of the Feature.

### `ralph`

Installs the `ralph` CLI from [iyaki/specralph](https://github.com/iyaki/specralph) for running AI Agentic Loop workflows.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/ralph:": {
            "version": "latest"
        }
    }
}
```

```bash
$ ralph --help

# Ralph script installed and ready to use
```

### `lefthook`

Installs `lefthook` from GitHub Releases.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/lefthook:": {
            "version": "latest"
        }
    }
}
```

```bash
$ lefthook version

# Lefthook installed and ready to use
```

### `pie`

Installs PIE — the official PHP extension installer (replaces PECL) — from [php/pie](https://github.com/php/pie) GitHub Releases as a self-contained static binary.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/pie:": {
            "version": "latest"
        }
    }
}
```

```bash
$ pie --version

# PIE installed and ready to use
```

### `pie-extensions`

Installs PHP extensions using PIE — the official PHP extension installer (replaces PECL) — into the PHP installation provided by a PHP runtime feature. Requires the [`pie`](#pie) feature and a PHP runtime with build tools (e.g. [`ghcr.io/devcontainers/features/php`](https://github.com/devcontainers/features/tree/main/src/php)).

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/devcontainers/features/php": {
            "version": "8.4"
        },
        "ghcr.io/iyaki/devcontainer-features/pie-extensions:": {
            "extensions": "apcu/apcu,xdebug/xdebug"
        }
    }
}
```

```bash
$ php -m | grep -E 'apcu|xdebug'

# Extensions installed and enabled
```

### `phpantom`

Installs PHPantom — a fast, lightweight PHP language server written in Rust — from [PHPantom-dev/phpantom_lsp](https://github.com/PHPantom-dev/phpantom_lsp) GitHub Releases as a self-contained binary bundled with phpstorm-stubs, so it needs no PHP runtime.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/phpantom:": {
            "version": "latest"
        }
    }
}
```

```bash
$ phpantom_lsp --version

# PHPantom installed and ready to use
```


## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder.  Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.


An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time.  Implementing tools are also free to process attributes under the `customizations` property as desired.
