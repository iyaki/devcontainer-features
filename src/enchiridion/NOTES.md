# Notes

Installs `enchiridion` from the public `iyaki/enchiridion` GitHub
Releases (no authentication required — plain release-download URLs, no
GitHub API calls, so no rate limits on shared CI runners) and supports
`x86_64` and `arm64` Linux architectures.

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

- [enchiridion repository](https://github.com/iyaki/enchiridion) (public)
