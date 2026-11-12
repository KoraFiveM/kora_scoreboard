# kora_scoreboard agent guide

`kora_scoreboard` is a Kora scoreboard resource: a `kora_lib` NUI app showing online players, on-duty police and the readiness of police-gated activities, plus optional nearby player ID labels. Layout: `fxmanifest.lua`, `shared/config.lua` (config registered via `Kora.config`), `client/client.lua` (app, key mapping, ID drawing), `server/server.lua` (data callback and busy-state relay), `fft_hooks.lua` (optional dev hooks), `test/` (offline Lua check) and `tests/` (kora_qa feature files).

## Documentation

User-facing documentation lives in `docs/` (Markdown, published via the Kora Docusaurus site, kora_docs_next). Read `docs/index.md` first for an overview of features, configuration, commands, events and dependencies.

When you add, change, or remove a feature, config option, command, export, event, item, permission, or database table/column, update the matching page in `docs/` in the same change. Keep docs accurate to the code; do not document behaviour that does not exist.

Docs rules: plain Markdown with `title`/`sidebar_position` front matter (no `id`/`slug`), relative links only between docs pages, assets inside `docs/`, fenced code blocks with a language, and no raw `<`, `>`, `{`, `}` outside code (pages are parsed as MDX). The release version comes from `fxmanifest.lua`'s `version` field.
