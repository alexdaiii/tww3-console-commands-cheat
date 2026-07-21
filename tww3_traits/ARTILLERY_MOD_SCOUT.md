# ARTILLERY MOD — SCOUT BRIEF

Recon notes for the "new artillery units" mod. **This is a scout task, not the build.**
Goal of the scout: read the DB dump and map out *exactly* which tables/rows we'd have to
clone + edit in RPFM to create two new artillery units. Output a per-unit table checklist,
not a mod.

Read `HANDOFF.md` first for kit conventions and the `read_tsv` `#comment`-skip rule.

## Reality check (do not lose this)
- This mod is **NOT scriptable**. The `tww3_traits/` kit grants *existing* content via Lua
  console commands. New units are **data** and must ship as a `.pack` built in **RPFM**
  (Rusted PackFile Manager). The dump here is for **recon only** — figure out what to clone.
- Target approach for both units = **Tier 2**: clone an existing artillery unit, reuse
  existing models/projectiles/VFX, re-stat + re-skin + re-name. **No new 3D art.**
- Scope for v1: **only 2 factions the user is playing** — Grand Cathay and Kairos
  Fateweaver (Tzeentch). NOT "all factions" yet. Get the pattern right on two first.

## Unit 1 — Cathay "Dragon Rocket Battery" (thunderclap-style, upgunned)
**Design intent (REVISED):** NOT a straight Fire Rain reskin. Make it play like a
**thunderclap bomb** — a heavier **lobbing mortar**: fewer, bigger, harder-hitting
**explosive shells** with a strong concussive **shockwave/knockback**, arcing fire — and
**more powerful** than the base Fire Rain battery (higher tier / cost to match). Dragon
theming on the launcher + a big dragon-breath fireball explosion. Lore-adjacent: real Ming
"flying-cloud thunderclap eruptor" (see lore notes) — a mortar is a genuine gap in Cathay's
roster, so this is a *new-feeling* unit, not a palette swap.

- **Unit chassis / crew / recruitment template:** clone
  `wh3_main_cth_art_fire_rain_rocket_battery_0` (reuse its model, crew, launcher, campaign
  plumbing — Cathay-appropriate art already there).
- **BUT the projectile is the redesign. DECISION: graft a mortar projectile (path 2).**
  Fire Rain fires *many small* rockets in a spread; we want *few, heavy* explosive shells.
  **Chosen approach:** clone the projectile/explosion chain from an existing lobbing mortar
  and graft it onto the Cathay Fire Rain chassis (keep Cathay model/crew/recruitment, swap
  the "what it fires" for a real mortar shell) → truer thunderclap arc + blast.
  - Scout must **pick the best donor mortar** and list its full projectile chain keys.
    Candidates to evaluate: Empire Mortar, Grudge Thrower/other lobbers, Chaos Dwarf
    Magma/Deathshrieker pieces. Criteria: clean high-arc lob, big single explosive shell,
    strong shockwave/knockback, reusable without pulling in race-locked VFX.
  - Then re-flavor the grafted shell as dragon-fire (explosion + display swap) and upgun it.
  - (Path 1 — just retuning Fire Rain's own projectile — is the fallback if a donor mortar
    drags in blockers; note it as fallback only.)
- Scout must trace the FULL clone chain and flag which rows change vs. copy-as-is:
  - `main_units` (bump tier/recruit cost/upkeep — it's the *upgunned* variant) → `land_units`
    → `unit_stats_land`
  - missile weapon → `missile_weapons` → `missile_weapons_to_projectiles` → `projectiles`
    → `projectiles_explosions` / `projectile_displays` / `projectile_impacts`
    **← this is the thunderclap redesign: projectile_number ↓, damage/ap ↑, shockwave_radius ↑,
    explosion + display swapped to a big dragon-fire blast.**
  - `unit_variants` / variant model refs (keep existing launcher; note the key)
  - loc: `WH3-Dump/text/db/land_units__.loc.tsv` (+ descriptions) — name it "Dragon Rocket
    Battery" (or "Dragon Thunderclap Battery" — user's pick later)
- Deliverable additions for this unit: the **exact projectile columns** that turn "many
  rockets" into "few heavy thunderclap shells," and a candidate **mortar donor** if path 2
  is cleaner. Note whether the shockwave/knockback is a projectile field or a separate
  explosion/contact-effect table.
- Note: fire_rain also appears in `allied_recruitment_*`, `armed_citizenry_*`, and audio
  tables — list which are cosmetic vs. required so the build doesn't over-clone.

## Unit 2 — Kairos/Tzeentch "Bloated Horror Launcher" (working name)
**Design intent:** launches a **Pink Horror bloated with magic** that, when it lands, does a
bunch of **weird random magic effects**. Tzeentch has **NO artillery** in the base roster
(HANDOFF confirms — Exalted Flamers are the stand-in), so this is the ambitious/fun one and
the more interesting scout.

- **No same-race template exists.** Scout must pick the best *mechanical* donor to clone:
  - Body/crew/animation donor: a lobbing artillery piece (mortar/catapult style) whose
    firing arc suits "launch a blob." Candidates to compare: Empire Mortar, a catapult-type,
    or a Chaos Dwarf magma/deathshrieker piece. List 2–3 with pros/cons.
  - The "launched pink horror" = the projectile. Find how a Pink Horror model could be
    referenced as a projectile display, OR whether we fake it with an existing round blob +
    Tzeentch-pink VFX. Note both options.
- **"Random magic effects on landing"** is the hard/interesting part — scout the mechanics:
  - `projectiles_explosions`, `projectile_impacts`, `contact_stat_effect` on `projectiles`.
  - Vortex system: `battle_vortexs_tables`, `battle_vortex_shapes`, `battle_vortex_*` —
    can a projectile impact spawn a vortex? Is there a "random spell" table anywhere?
  - `special_ability_*` group tables — is there an existing "cast random spell" behaviour
    (Tzeentch is the random-magic faction — check for existing Miscast/Curse-of-Tzeentch
    style effects to reuse)?
  - Pink→Blue Horror split mechanic: find how that's encoded (a unit_set / grouping /
    ability) — it may be the cleanest hook for "spawns random stuff on landing."
  - **Deliverable for this unit:** a ranked list of "how random-on-landing could actually be
    implemented with existing tables," from easiest (single fixed magic explosion, reskinned)
    to hardest (true random spell selection), with the table keys each would touch.

## Roster / recruitment plumbing (both units)
Once the unit data exists, it has to be *recruitable* by the target faction. Scout the tables:
- `units_to_groupings_military_permissions_tables` — the who-can-recruit gate. Find Cathay's
  and Tzeentch's grouping keys and how the existing Fire Rain battery / a Tzeentch unit is
  granted.
- Recruitment source: a building or tech unlock — find where existing Cathay artillery /
  Tzeentch units are unlocked (`building_units_allowed_tables` and friends).
- `armed_citizenry_*` (garrison), unit caps, `ui_unit_group_land`, tier — note which are
  required vs. optional for v1.

## Scout output format (what to hand back)
For **each** of the two units, produce:
1. A **clone checklist**: table → key(s) to duplicate → what to change (or "copy as-is").
2. The **reskin/VFX levers**: exactly which projectile/explosion/display rows control the
   "look" so we know what to swap for "cooler fire" / "pink magic blob."
3. For Kairos unit only: the **ranked feasibility list** for random-on-landing magic.
4. Any **blockers** (e.g. "random spell needs a new table with no template" → flag it).
5. Loc keys to add for names/descriptions.

Keep it grounded in rows that actually exist in `WH3-Dump/`. Cite `table/data__.tsv:col`.
Do NOT edit the dump or write a .pack — recon only.

## Confirmed anchors (already found, don't re-derive)
- Cathay existing rocket battery: `wh3_main_cth_art_fire_rain_rocket_battery_0` (main_units).
  Also has `wh3_main_cth_art_grand_cannon_0`.
- `projectiles_tables` schema includes: shot_type, explosion_type, damage/ap_damage,
  bonus_v_infantry/large, projectile_display, contact_stat_effect, shockwave_radius,
  can_damage_buildings, gravity — the reskin + "on-land effect" knobs live here.
- `projectile_bombardments_tables` (bombardment_key, num_projectiles, projectile_type,
  radius_spread, launch_source, launch_vfx, randomise_launch) — the lobbed-arrival system.
- No bombardment currently references "vortex" (grep = 0) — a projectile→vortex link would be
  new ground; verify whether any impact/explosion spawns a vortex before assuming it's easy.
- Permission gate table: `units_to_groupings_military_permissions_tables`.
- Loc: `WH3-Dump/text/db/land_units__.loc.tsv`.
