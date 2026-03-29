
# Ralph Agentic Loop runner

AI Agentic Loop shell runner aimed for spec-driven development workflows.

## Example Usage

```json
"features": {
    "ghcr.io/iyaki/devcontainer-features/ralph:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Release version to install. Use `latest` or a release tag such as `v2.0.0`. | string | latest |


This feature installs the `ralph` script to `/usr/local/bin/ralph` by default, so it can be run with `ralph` from the terminal.

To pin the script to a specific release, set the `version` option to a release tag such as `v2.0.0`. To always install the newest published release, use `latest` (the default).

For example usage of the `ralph` script and proper documentation, see the [iyaki/ralph repository](https://github.com/iyaki/ralph).


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/iyaki/devcontainer-features/blob/main/src/ralph/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
