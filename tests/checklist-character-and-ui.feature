# Converted from the communitybot legacy tests by kora-qa-panel/scripts/convert-legacy.mjs.
# The """ block under each Scenario is the original test text, verbatim. Review before applying.
Feature: kora_scoreboard — Character & UI

  @kora_scoreboard @checklist @checklist:kora_scoreboard:open-key @cat:character-and-ui
  Scenario: Open scoreboard with HOME key
    """
    Checklist test: Press HOME (rebindable in FiveM keybinds as 'Open Scoreboard'); toggles open/closed by default, Escape also closes.
    """
    When I press the "HOME" key
    Then the "qb-scoreboard:app" app should be open
    When I press the "HOME" key
    Then I confirm: the scoreboard panel closes
    When I press the "HOME" key
    And I press the "ESCAPE" key
    Then I confirm: the scoreboard panel closes
    When I manually: rebind 'Open Scoreboard' in FiveM keybinds to another key and press it
    Then the "qb-scoreboard:app" app should be open

  @kora_scoreboard @checklist @checklist:kora_scoreboard:scoreboard-command @cat:character-and-ui
  Scenario: /scoreboard command
    """
    Checklist test: Type /scoreboard to toggle the panel open and closed.
    """
    When I run the command "/scoreboard"
    Then the "qb-scoreboard:app" app should be open
    When I run the command "/scoreboard"
    Then I confirm: the scoreboard panel closes

  @kora_scoreboard @checklist @checklist:kora_scoreboard:overview-stats @cat:character-and-ui
  Scenario: Players online and police on duty
    """
    Checklist test: Panel shows 'Players online X / max' and 'Police on duty' counts; compare with real counts and an on-duty police player.
    """
    When I run the command "/scoreboard"
    Then the "qb-scoreboard:app" app should be open
    And I confirm: the panel shows 'Players online X / max' with X matching the real number of players online
    And I confirm: the panel shows a 'Police on duty' count
    When I manually: ask a second player with the police job to go on duty
    Then I confirm: the 'Police on duty' count increases by 1

  @kora_scoreboard @checklist @checklist:kora_scoreboard:activity-table @cat:character-and-ui
  Scenario: Police-gated activities table
    """
    Checklist test: Table lists Store Robbery/Bank/Jewelery/Pacific/Paleto with required police and Ready / Needs more police status badges.
    """
    When I run the command "/scoreboard"
    Then the "qb-scoreboard:app" app should be open
    And I confirm: the table lists Store Robbery, Bank, Jewelery, Pacific and Paleto
    And I confirm: each activity row shows its required police count
    And I confirm: each row shows a 'Ready' or 'Needs more police' status badge matching the current police on duty

  @kora_scoreboard @checklist @checklist:kora_scoreboard:activity-busy @cat:character-and-ui @needs:admin
  Scenario: Activity On cooldown status
    """
    Checklist test: When a resource fires qb-scoreboard:server:SetActivityBusy(activity,true) the row shows 'On cooldown' (server-trusted only).
    """
    When I run the command "/scoreboard"
    And I manually: in the server console (txAdmin live console) type: lua TriggerEvent('qb-scoreboard:server:SetActivityBusy', '<activityId>', true), using the id of an activity row shown on the scoreboard
    Then I confirm: the matching activity row shows 'On cooldown'
    When I manually: in the server console type: lua TriggerEvent('qb-scoreboard:server:SetActivityBusy', '<activityId>', false), using the same activity id
    Then I confirm: the row no longer shows 'On cooldown'

  @kora_scoreboard @checklist @checklist:kora_scoreboard:nearby-ids @cat:character-and-ui
  Scenario: Nearby player IDs while open
    """
    Checklist test: With panel open, [id] labels appear above players within 10m if they opted in (or Show nearby player IDs is on).
    """
    When I run the command "/scoreboard"
    And I manually: ask a second player to stand within 10 metres of me
    Then I confirm: an [id] label appears above the second player (only applies if they opted in or Show nearby player IDs is on; otherwise mark Pass if no label appears)
    When I manually: ask the second player to move more than 10 metres away
    Then I confirm: the [id] label above the second player disappears

  @kora_scoreboard @checklist @checklist:kora_scoreboard:hold-mode @cat:character-and-ui @needs:admin
  Scenario: Hold-to-view mode
    """
    Checklist test: If Config.Toggle is off via /config, the panel shows only while the key is held.
    """
    When I run the command "/config"
    And I manually: set Config.Toggle to off in the config menu if you have access
    And I manually: hold the scoreboard key (HOME)
    Then I confirm: the scoreboard panel shows only while the key is held (only applies when Config.Toggle is off)
    When I manually: release the scoreboard key
    Then I confirm: the scoreboard panel closes
