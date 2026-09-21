
# Enchiridion (enchiridion)

Installs enchiridion — the Notion knowledge-base mirror CLI — from the private iyaki/enchiridion GitHub Releases (authenticated download).

## Example Usage

```json
"features": {
    "ghcr.io/iyaki/devcontainer-features/enchiridion:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| github_token | GitHub token with contents:read on iyaki/enchiridion (the repository is private). Reads ${localEnv:GITHUB_TOKEN} when empty. | string | - |
| version | enchiridion release version to install (for example: 0.1.0). Use 'latest' for the newest release. | string | latest |
| enchiridion_home | Cache root for the mirrored knowledge base. Leave empty for the default ~/.local/share/enchiridion. | string | - |

# Notes

Installs `enchiridion` from the **private** `iyaki/enchiridion` GitHub
Releases (authenticated API download) and supports `x86_64` and `arm64`
Linux architectures.

## Authentication (required)

The release download needs a token with **contents:read** on
`iyaki/enchiridion`. Set it through the `github_token` option in the
consumer's `devcontainer.json`:

```json
{
    "name": "My project",
    "features": {
        "ghcr.io/iyaki/devcontainer-features/enchiridion:1": {
            "github_token": "${localEnv:GITHUB_TOKEN}"
        }
    }
}
```

`GITHUB_TOKEN` / `ENCHIRIDION_TOKEN` environment variables during the
build work too. Without any token the build fails fast with
instructions — never silently.

## Running the sync

`enchiridion sync` needs `NOTION_TOKEN` and
`KNOWLEDGE_BASE_DATASOURCE_ID` (read-only integration; ADR-11). Expose
them at runtime and sync on container start:

```json
{
    "remoteEnv": {
        "NOTION_TOKEN": "${localEnv:NOTION_TOKEN}",
        "KNOWLEDGE_BASE_DATASOURCE_ID": "${localEnv:KNOWLEDGE_BASE_DATASOURCE_ID}"
    },
    "postCreateCommand": "enchiridion sync"
}
```

First run has an empty cache: auto-backfill performs a full sync
(minutes; ADR-10 records this accepted cost). Successive starts are
incremental.

## Cache root

Set the `enchiridion_home` option to move the cache; it is persisted to
`/etc/profile.d/enchiridion.sh` (login shells). For non-login tooling,
set `ENCHIRIDION_HOME` in your `devcontainer.json` `containerEnv` or
`remoteEnv` — the binary reads the variable directly.

Additional resources:

- [enchiridion repository](https://github.com/iyaki/enchiridion) (private)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/iyaki/devcontainer-features/blob/main/src/enchiridion/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
