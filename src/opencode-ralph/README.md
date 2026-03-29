
# Ralph Agentic Loop runner for OpenCode (opencode-ralph)

POSIX-compliant AI Agentic Loop shell runner aimed for spec-driven development workflows.

## Example Usage

```json
"features": {
    "ghcr.io/iyaki/devcontainer-features/opencode-ralph:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Release version to install. Use 'latest' or a release tag such as 'v2.0.0'. | string | latest |
| installDir | Directory to install the ralph executable. | string | /usr/local/bin |

# Additional Notes

- Ralph CLI repository: [iyaki/ralph](https://github.com/iyaki/ralph)

## Requirements

- `curl` for fetching the script (installed automatically when possible)
- `opencode` CLI for running the agentic loop (automatically installed, using the [opencode feature](https://ghcr.io/devcontainers-extra/features/opencode) from devcontainers-extra)

## Usage

This feature installs the `ralph` CLI to `/usr/local/bin/ralph` by default, so it can be run with `ralph` from the terminal.

To pin the script to a specific release, set the `version` option to a release tag such as `v1.0.1`. To always install the newest published release, use `latest`.

For example usage of the `ralph` CLI and proper documentation, see the [iyaki/ralph repository](https://github.com/iyaki/ralph).


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/iyaki/devcontainer-features/blob/main/src/opencode-ralph/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
