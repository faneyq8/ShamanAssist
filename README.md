# Shaman Assist 0.3.0 Beta 1

Shaman Assist provides combat alerts, proc trackers, buff timers, cooldown timelines, and action-button glows for World of Warcraft Retail.

It supports **Enhancement, Elemental, and Restoration**, automatically detects specialization changes, and keeps separate alert settings and positions for each specialization. The General page also provides a manual specialization selector for configuration and testing.

The addon includes 34 hero talent alert entries covering Stormbringer, Totemic, and Farseer across all six specialization and hero-tree combinations. Gameplay alerts follow the character's active specialization and hero tree. See `HERO-TALENTS.md` for the coverage matrix and tracking details.

## Installation

1. Extract the archive and copy the `ShamanAssist` folder to `_retail_/Interface/AddOns/`.
2. Confirm the final path is `AddOns/ShamanAssist/ShamanAssist.toc`.
3. Start World of Warcraft and enable Shaman Assist in the AddOns list. Restart the game if it was open during installation.
4. Open settings with `/sha` or the minimap button.

## Specialization support

- **Enhancement:** Maelstrom Weapon, Stormstrike, Hot Hand / Lava Lash, Tempest, Lightning Shield, weapon imbues, Crash Lightning, Doom Winds, Ascendance, and hero talent alerts.
- **Elemental:** Lava Surge, Tempest Buff, Ascendance timeline, Lightning Shield, main-hand weapon imbue reminder, and hero talent alerts.
- **Restoration:** Tidal Waves, Ascendance timeline, Water Shield, self-cast Earth Shield tracking, Earthliving weapon reminder, and hero talent alerts. Earth Shield currently tracks the player only, not party or raid members.
- **Test All and Edit Layout:** display alerts only for the specialization selected in General, including both hero trees available to that specialization. Changing specialization stops previews and discards unsaved layout moves.

## Features

- **Tempest Buff:** a dedicated display for the active buff, stacks, and remaining duration when available, separate from the Tempest readiness alert.
- **Ascendance:** an enabled-by-default timeline using the buff's actual remaining duration. It updates when extended and hides when the buff expires or is removed.
- **Doom Winds:** a buff icon using texture `8026696`, with remaining time and an optional timeline.
- Independent icon, text, timer, stack, bar, width, color, sound, and glow options for supported displays.
- Movable alert icons, text, and timelines through Edit Layout mode.
- A persistent **Test All** button at the top of settings. It previews every alert for the selected specialization for 20 seconds, including disabled alerts, without changing saved settings.
- **Stop Test** ends the preview. Previews also stop when settings close or combat begins.
- A custom Shaman icon representing Enhancement, Elemental, and Restoration in the minimap button, addon list, and settings window.
- Maelstrom Weapon tracking with a bar and configurable threshold from 1 to 10; the default is 10.
- Crash Lightning missing-buff tracking with an optional action-button glow.
- Lightning Shield and temporary weapon-enchant reminders.
- Four glow styles with separate options for action buttons and Blizzard Cooldown Manager.
- Blizzard, Bartender, Dominos, ElvUI, and Ellesmere action-button discovery through known frames and naming patterns.
- Minimap button and Addon Compartment support.
- Independent saved settings in `ShamanAssistDB`, allowing installation alongside DK Assist.

## Commands

| Command | Action |
|---|---|
| `/sha` | Open settings |
| `/sha test` | Preview every alert for the selected specialization for 20 seconds; individual tests last 6 seconds |
| `/sha stop` | Stop the current preview |
| `/sha unlock` | Show the preview and allow alert positions to be moved |
| `/sha lock` | Save and lock alert positions, then stop the preview |
| `/sha rescan` | Rescan action buttons and Cooldown Manager outside combat |
| `/sha status` | Print alert-source and detection status in chat |

## Beta notes and known limits

- If Tempest, Ascendance, or Doom Winds does not appear during combat, add it to **Tracked Buffs** in Blizzard Cooldown Manager and run `/sha rescan` outside combat. The addon uses the known frame's buff state and duration identifier when direct aura data is unavailable.
- Timelines do not start from a spell cast or a fixed assumed duration. They use the actual buff duration. A known active buff without readable duration shows `--`; a confirmed timeless buff shows `Active`.
- Buff counters and bars update only while a temporary display is visible; the addon does not scan buffs or buttons every frame.
- Retail interface `120100` is targeted. The files passed Lua 5.1 syntax checks and simulated logic tests. This beta still requires continued verification in the live game.
- Proc alerts follow Blizzard proc signals or readable player auras. They are not rotation recommendations and never activate abilities.
- If stack data is restricted during combat, the addon reads the display API when possible and otherwise shows `?`. It never guesses a hidden stack count.
- Crash Lightning tracks the confirmed absence of its buff, including its alternate buff variant. It does not require a target count or spell-ready check.
- Missing combat aura data is not treated as proof that a buff is absent, so some missing-buff reminders may pause when the game restricts the source.
- Tempest proc tracking depends on Tempest being available in the selected build.
- If action pages or macros change during combat, stale button links are cleared and rescanning waits until combat ends. Standalone alert icons continue working.
- For a first test, open `/sha`, run **Test All**, then test against a training dummy. Use `/sha status` to identify the data source if an alert does not appear.

## Attribution

Shared settings controls, theme palettes, glow wrappers, minimap launcher, and button discovery patterns are adapted from DK Assist 2.1.9. The original MIT license is included in `LICENSE`. Bundled LibStub and LibCustomGlow retain their source headers.

Current API signatures were checked against Blizzard's generated documentation mirrored in [wow-ui-source](https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_APIDocumentationGenerated), including [aura data](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitAuraDocumentation.lua), [specializations](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SpecializationInfoDocumentation.lua), and [temporary enchants](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/PaperDollInfoDocumentation.lua). Enhancement aura IDs were cross-checked against [SimulationCraft's Shaman implementation](https://github.com/simulationcraft/simc/blob/midnight/engine/class_modules/sc_shaman.cpp).
