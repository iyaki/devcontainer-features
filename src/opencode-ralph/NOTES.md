# Additional Notes

- Ralph script repository: [iyaki/ralph](https://github.com/iyaki/ralph)

## Requirements

- `curl` for fetching the script (installed automatically when possible)
- `opencode` CLI for running the agentic loop

For opencode installation, see [OpenCode](https://opencode.ai/) or use the [devcontainers-extra feature](http://github.com/devcontainers-extra/features/tree/main/src/opencode) (`ghcr.io/devcontainers-extra/features/opencode:1`).

## Usage

This feature installs the `ralph` script to `/usr/local/bin/ralph` by default, so it can be run with `ralph` from the terminal.

To pin the script to a tag or commit, set the `version` option to the desired Git ref.

For example usage of the `ralph` script and proper documentation, see the [iyaki/ralph repository](https://github.com/iyaki/ralph).
