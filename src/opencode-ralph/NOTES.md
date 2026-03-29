# Additional Notes

This feature is deprecated and maintained only for legacy purposes. Consider using the `ralph` Feature instead.

- Ralph CLI repository: [iyaki/ralph](https://github.com/iyaki/ralph)

## Requirements

- `curl` for fetching the script (installed automatically when possible)
- `opencode` CLI for running the agentic loop (automatically installed, using the [opencode feature](https://ghcr.io/devcontainers-extra/features/opencode) from devcontainers-extra)

## Usage

This feature installs the `ralph` CLI to `/usr/local/bin/ralph` by default, so it can be run with `ralph` from the terminal.

To pin the script to a specific release, set the `version` option to a release tag such as `v1.0.1`. To always install the newest published release, use `latest`.

For example usage of the `ralph` CLI and proper documentation, see the [iyaki/ralph repository](https://github.com/iyaki/ralph).
