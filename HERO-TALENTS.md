# Hero talent coverage — 0.3.0

Reviewed on 2026-09-23 against the current Midnight talent and spell data. This addon displays actual player buffs and confirmed totems; it does not simulate rotations or estimate buff durations from spell casts.

## Stormbringer — Elemental and Enhancement

| Talent / effect | Coverage |
|---|---|
| Tempest | Existing Tempest aura and Enhancement proc display; assigned to Stormbringer |
| Unlimited Power | New buff, stacks and duration for both specs |
| Storm Swell | New buff and duration for both specs |
| Arc Discharge | Enhancement: buff 470532. Elemental: actual Stormkeeper buff 191634, including stacks; no fictitious separate Arc Discharge buff |
| Surging Currents | New buff and stacks for both specs |
| Electroshock / Lightning Conduit | Separate actual movement buffs for both specs |
| Rolling Thunder | Enhancement: Nature Spirit (Crackling Surge) buff. Elemental: Stormkeeper display; no cooldown prediction |
| Awakening Storms / Descending Skies | Resulting Tempest proc covered; old 3/12-stack Awakening counters are not inferred from the current proc-based talent |
| Stormcaller, Supercharge, Conductive Energy, Voltaic Surge, Nature's Protection, Natural Gift, Stormwell | Spell/stat/resource/cooldown modifiers; no separate fabricated player buff. Lightning Shield upkeep already covered |

## Totemic — Enhancement and Restoration

| Talent / effect | Coverage |
|---|---|
| Surging Totem | New icon and default timeline for both specs. Uses actual totem identity and native duration, with aura / Tracked Buff fallback |
| Whirling Elements | Enhancement: Air, Earth, Fire. Restoration: Air, Earth, Water. Each has its own icon, duration and options |
| Amplification Core / Wind Barrier | Actual player buffs for both specs |
| Totemic Rebound | Enhancement stacking buff. Restoration's extra Chain Heal is an automatic effect, not a separate tracked player buff |
| Lively Totems | Enhancement actual buff. Restoration's instant Chain Heal is an automatic effect |
| Primal Catalyst | Enhancement current aura 1260880. Restoration's Earthliving application is an automatic effect on healed allies |
| Totemic Momentum | Enhancement Hot Hand duration already refreshes from actual aura data. Restoration cooldown modifier has no extra buff timer |
| Oversized Totems, Swift Recall, Pulse Capacitor, Supportive Imbuements, Imbuement Mastery, Splitstream, Oversurge, Totemic Coordination, Earthsurge, Elemental Attunement | Passive/triggered modifiers; reflected in actual affected buffs/totems, without invented standalone timers |

## Farseer — Elemental and Restoration

| Talent / effect | Coverage |
|---|---|
| Call of the Ancestors | Actual player aura 447244, stacks and default timeline for both specs. Aura stacks/duration are not claimed to enumerate every independently timed summoned Ancestor |
| Ancestral Swiftness | Actual buff for both specs |
| Mystic Knowledge | Restoration recharge buff 1270453; added Restoration Lava Surge proc display. Elemental Lava Surge already covered |
| Ancestral Influence | Actual Call of the Ancestors aura; no inferred Intellect bonus |
| Heed My Call, Routine Communication, Ancient Fellowship, Latent Wisdom, Elemental Reverb, Offering from Beyond, Final Calling | Modify Ancestors or their effects. Changes to the readable Ancestors buff are reflected automatically; no guessed summon counts |
| Primordial Capacity, Spiritwalker's Momentum, Maelstrom Supremacy, Natural Harmony, Earthen Communion, Windspeaker | Passive/resource/spell modifiers; no independent alert timer added |

## Behavior and limits

- Live alerts follow the real specialization and hero subtree (Totemic 54, Stormbringer 55, Farseer 56). If the hero API is unavailable, confirmed aura evidence is still accepted.
- Manual spec selection affects settings and preview only. Test All and Edit Layout show the selected spec's alerts, including both of its hero trees for configuration; they do not change gameplay talents.
- New alerts have independent saved positions and appearance. Use Next / Previous in the sidebar to reach all pages.
- Restricted or unavailable data never produces a guessed timer. Add supported buff entries to Blizzard Tracked Buffs when direct combat aura reads are unavailable.
- Tests ran in a mock client, including all six hero/spec combinations, aura removal, hero changes, native totem timers, secret-value rejection and pagination. Live combat and visual validation remain necessary.

## Primary implementation references

- [SimulationCraft current Shaman implementation](https://github.com/simulationcraft/simc/blob/midnight/engine/class_modules/sc_shaman.cpp)
- [Current talent definitions and hero subtree IDs](https://github.com/simulationcraft/simc/blob/midnight/engine/dbc/generated/trait_data.inc)
- [Current extracted spell data](https://github.com/simulationcraft/simc/blob/midnight/engine/dbc/generated/sc_spell_data.inc)
- [Blizzard hero talent API](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/ClassTalentsDocumentation.lua)
- [Blizzard totem API](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/TotemDocumentation.lua)
