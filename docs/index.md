---
title: kora_scoreboard
sidebar_position: 1
---

# kora_scoreboard

`kora_scoreboard` is a Kora scoreboard. A key press or the `/scoreboard` command opens a compact `kora_lib` NUI app on the right of the screen that shows how many players are online, how many police are on duty, and whether each configured police-gated activity (robberies) is ready, on cooldown or short of police. While the scoreboard is open it can also draw `[id]` labels above nearby players. It is a rewrite of `qb-scoreboard` and still uses the legacy `qb-scoreboard:*` event, callback and app names.

Current version: see `version` in `fxmanifest.lua`.

## Pages

- [Features](./features.md) - what the scoreboard shows and how it behaves.
- [Configuration](./configuration.md) - every config option and the default activities.
- [Commands and key binding](./commands.md) - `/scoreboard`, the key mapping, toggle and hold modes.
- [Events and callbacks](./events.md) - the server callback and the busy-state event for robbery scripts.
- [Installation and dependencies](./installation.md) - requirements, setup and tests.
- [Troubleshooting](./troubleshooting.md) - common problems and known limitations.

## Quick start

1. Make sure `kora_lib` and `kora_core` start before this resource.
2. `ensure kora_scoreboard`.
3. Press `HOME` in game (or run `/scoreboard`).
4. Set the police requirements in the config so they match your robbery scripts.
