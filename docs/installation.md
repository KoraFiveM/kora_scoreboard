---
title: Installation and dependencies
sidebar_position: 6
---

# Installation and dependencies

## Requirements

Declared with `dependency` in `fxmanifest.lua`:

| Resource | Used for |
| --- | --- |
| [kora_lib](https://github.com/KoraFiveM/kora_lib) | `@kora_lib/init.lua`, `Kora.nui` app shell, `Kora.config`, `Kora.callback` |
| [kora_core](https://github.com/KoraFiveM/kora_core) | `createCallback`, `getAllPlayers` and `isOptin` exports |

There is no database use, no items and no locale files. Text in the UI is hardcoded in English in `client/client.lua`.

## Install

1. Place the resource folder as `kora_scoreboard`.
2. Ensure `kora_lib` and `kora_core` before it.
3. `ensure kora_scoreboard`.

## Robbery script integration

Call `qb-scoreboard:server:SetActivityBusy` from the server side of your robbery scripts, using the ids from [Configuration](./configuration.md). See [Events](./events.md).

## Tests

- `bash test/run.sh` runs `lua test/settings.lua`, an offline configuration check.
- `tests/checklist-character-and-ui.feature` contains Gherkin scenarios for `kora_qa` (declared with `qa_feature` in the manifest): open key, `/scoreboard`, stats, activity table, cooldown status, nearby IDs and hold mode.

## Licence

GPL-3.0-or-later, see `LICENSE`.
