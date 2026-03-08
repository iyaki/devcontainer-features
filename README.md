# Dev Container Features

This repository contains a collection of dev container Features for use with [Dev Containers](https://containers.dev/).

## Features

This repository contains the following Features:

- **opencode-ralph** - POSIX-compliant AI Agentic Loop shell runner for spec-driven development workflows
- **lefthook** - Git hooks manager for fast and powerful Git hook workflows

Each sub-section below shows a sample `devcontainer.json` alongside example usage of the Feature.

### `opencode-ralph`

Installs the `ralph` script for running AI Agentic Loop workflows with OpenCode.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/opencode-ralph:1": {
            "version": "main"
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
        "ghcr.io/iyaki/devcontainer-features/lefthook:1": {
            "version": "latest"
        }
    }
}
```

```bash
$ lefthook version

# Lefthook installed and ready to use
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder.  Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.


An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time.  Implementing tools are also free to process attributes under the `customizations` property as desired.
