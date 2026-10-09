# 0.3.0

- Reviewed all three Shaman hero trees and added 34 specialization-specific alert entries, including Stormbringer buffs, Totemic Whirling elements and Surging Totem, and Farseer Ancestors/Ancestral Swiftness/Mystic Knowledge. See HERO-TALENTS.md for coverage and passive effects.
- Added automatic hero subtree detection and live wrong-hero suppression, while preserving selected-spec preview and layout editing for both available hero trees.
- Track Surging Totem using confirmed native totem identity and duration, refreshing on PLAYER_TOTEM_UPDATE. No timers are inferred from casts.
- Paginated the alert sidebar to keep every settings page accessible.
- All local Lua regression checks passed, including all six spec/hero pairs and every new buff. In-game validation remains required.

# 0.2.1

- Added General specialization selector: Auto, Enhancement, Elemental and Restoration. Manual selection controls settings pages, Test All, Edit Layout and position reset; live tracking continues to follow the player's actual specialization.
- Save the selected view between sessions; clear previews and draft layout edits when changing views. During previews, suppress other live alerts and external glows so only the selected specialization appears.
- Regression tests passed for manual selection, preview/layout isolation, persistence and returning to Auto. In-game validation remains required.

# 0.2.0

- Added automatic Elemental (262), Enhancement (263) and Restoration (264) routing on login and specialization changes. Settings pages, active displays, Test All and Edit Layout follow the current specialization.
- Added Elemental Lava Surge, Tempest Buff, Ascendance timeline, Lightning Shield and main-hand imbue reminders.
- Added Restoration Tidal Waves, Ascendance timeline, Water Shield, Earth Shield on the player, and Earthliving imbue reminders. Imbue reminders detect absence of any temporary enchant, not its type.
- Each spec has separate alert settings and positions. Existing Enhancement preferences remain intact. Switching spec cancels previews and restores unsaved layout edits; global position reset affects only the current spec.
- Generalized the buff timer driver for all specs. Regression tests cover all specialization transitions, preview isolation, saved settings, new aura activation/removal and unsupported specializations. Live combat and visual validation remain required.

# 0.1.9

- Removed duplicate Test all alerts and Stop test buttons from General. The header buttons remain available on every page.

# 0.1.8

- Pin Doom Winds to Interface/Icons/Ability_IronMaidens_SwirlingVortex instead of resolving artwork through the spell API. This keeps its artwork independent of spell overrides. Ascendance and buff tracking are unchanged.

# 0.1.7

- Removed the Doom Winds texture override 8026696: that is Ascendance's artwork. Doom Winds now uses its own spell icon (384352), while Ascendance retains its native icon. Tracking and timers are unchanged.

# 0.1.6

- Added Edit Layout in the window header: hides settings and displays all icons, text alerts, stack bars and timelines until Save positions or Cancel. Save locks positions; Cancel restores the previous positions. Entering combat cancels editing.
- Themes now style every settings button, navigation selection, labels, checkmarks, card dividers, close button and layout toolbar as well as the window and cards.
- Local Lua regression tests passed, including editing beyond the old preview timeout, save/cancel and combat cleanup. In-game visual verification remains required.

# 0.1.5

- Recognize native Tracked Buff items moved by Ellesmere using their original viewer or Ellesmere's buff-origin metadata, including its resolved spell cache. Placeholder icons never count as active buffs.
- Preserve matching item bindings when Blizzard reassigns the same spell during combat; invalidate recycled items and refresh buff state on aura changes.
- Check Tracked Buff state even when the direct aura lookup returns no buff. Read native cached aura data and public instance IDs as fallbacks.
- Regression checks cover combat activation/removal, repeated assignment, recycling and placeholders. Local mock tests passed; real combat validation is still required. Doom Winds keeps texture 8026696.

# 0.1.4

- Changed the Doom Winds tracker icon to texture FileDataID 8026696. Buff and spell IDs remain unchanged.

# 0.1.3

- Added independent Tempest Buff, Ascendance and Doom Winds tracking pages. Existing Tempest proc settings remain unchanged.
- Ascendance shows a movable remaining-duration timeline by default; Tempest Buff and Doom Winds show buff icons with remaining time and optional timelines. Buff stacks, timer text, timeline width and visual style are configurable.
- Uses actual player aura data or known Tracked Buff item state. Aura instance duration objects are passed to native display methods without comparing or calculating restricted numeric values. No timer is estimated from a cast.
- Handles buff refresh/extensions, removal, known expiry and indefinite/unavailable duration. A shared 10 Hz display updater is attached only while a timed display is visible; it performs no aura or button scans.
- All-alert preview includes the three timelines. Timeline positions are saved and reset independently; existing user settings and positions are preserved.
- Local Lua regression tests passed for timer progress/extensions, stack display, secret-value rendering, Tracked Buff fallback, removal, movement, preview and cleanup. In-game validation remains required.

References: [Blizzard duration objects](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/LuaDurationObjectAPIDocumentation.lua), [status-bar API](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SimpleStatusBarAPIDocumentation.lua), and the Shaman spell reference linked below.

# 0.1.2

- Added persistent Test All and Stop Test buttons in the settings header, available from every page.
- All-alert preview forces every alert's icon, text, glow and Maelstrom bar on for 20 seconds without modifying saved toggles. Previews render above the settings window and restore the normal gameplay layer afterward.
- Stop, closing settings and entering combat end the preview. Individual alert tests retain their six-second duration.
- Added a custom icon combining Enhancement lightning/hammer, Elemental fire and Restoration water/leaf. Bundled as a 256x256 uncompressed TGA and wired into minimap, launcher, addon metadata and settings branding.
- Validated all-alert timing, disabled-option preview, restoration, cancellation and saved-settings preservation in the local Lua harness. In-game verification remains required.

# 0.1.1

- Added Crash Lightning missing-buff alert, enabled during combat by default, with an independent icon, optional text/sound, and action-button glow.
- Tracks both Crash Lightning aura IDs used by the current Shaman reference. Alert stops on confirmed buff presence and resumes on confirmed absence.
- Uses Blizzard's per-spell secrecy predicate before interpreting a missing combat aura; unavailable data never implies absence.
- Added a fallback using readable active state from known Blizzard Tracked Buff items. Ordinary ability cooldowns and frame visibility do not establish buff presence.
- Deferred buff refresh hooks handle CDM updates without polling; recycled/cleared CDM items are invalidated.
- Preserves existing alert settings and positions. Tempest is unchanged.

Validated with Lua 5.1 compilation and local regression tests, including combat transitions, alternate aura, restricted values, CDM state, recycled items, settings migration and independent Tempest behavior. In-game validation remains required.

API references: [Blizzard secrecy predicates](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/SecretPredicateAPIDocumentation.lua) and [Cooldown Viewer item state](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_CooldownViewer/CooldownViewer.lua). Aura references: [SimulationCraft Shaman module](https://github.com/simulationcraft/simc/blob/midnight/engine/class_modules/sc_shaman.cpp).
