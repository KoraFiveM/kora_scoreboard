---
title: Features
sidebar_position: 2
---

# Features

## Overview panel

The app is registered as `qb-scoreboard:app` (title "Scoreboard", compact layout, 580 by 620, placed on the right). It has one navigation entry, "Overview", titled "Server status", with two blocks:

- **Stats** - "Players online" shown as `online / capacity` and "Police on duty".
- **Table** - "Police-gated activities" with the columns Activity, Required police and Status. Rows are sorted alphabetically by the displayed activity name. If no activities are configured the table shows "No police-gated activities are configured."

## Counts

Numbers come from the server callback `qb-scoreboard:server:GetScoreboardData` (see [Events](./events.md)):

- Players online is the number of players returned by `kora_core` `getAllPlayers`.
- Police on duty counts players whose job name is exactly `police` and who are on duty. The job name is hardcoded.
- The capacity (`Config.MaxPlayers`) is display only. It defaults to the `sv_maxclients` convar (48 if unset).

The figures are fetched once each time the scoreboard is opened. They are not refreshed while the panel stays open.

## Activity status

For each entry in `Config.IllegalActions` the status badge is chosen in this order:

1. **On cooldown** (warning) - the activity has been flagged busy through `qb-scoreboard:server:SetActivityBusy`.
2. **Ready** (success) - police on duty is greater than or equal to the activity's `minimumPolice`.
3. **Needs more police** (destructive) - otherwise.

This is informational only. The scoreboard never blocks or starts a robbery; the robbery resource enforces its own rules.

## Nearby player IDs

While the app is open, the client scans for players within 10 metres every 500 ms and draws a white `[serverId]` label about one metre above each one's head. A label is drawn for a player when `Config.ShowIDforALL` is on, or when `kora_core` `isOptin` reports that player as opted in (the opt-in flag is read from the server when the scoreboard opens). Labels stop when the panel closes.

## Live configuration

Options are registered with `Kora.config`, so owners can edit them in the Kora config UI. Options marked live apply without a restart; see [Configuration](./configuration.md).

## Optional FFT hooks

`fft_hooks.lua` is a development hook for the `fft` test runner. It does nothing unless the convar `fft_kora_hooks` is `true`. When enabled it exports `fftVersion` and `fftAction` (only callable by the `fft` resource with an authorised session) and offers a read-only `view` action that summarises the last data sent to the app. It does not alter scoreboard behaviour.
