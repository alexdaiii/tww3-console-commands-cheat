# ARTILLERY MOD — RECON RESULTS (scout output, 2026-07-21)

Companion to `ARTILLERY_MOD_SCOUT.md` (the brief). This is the scout's findings — a build
checklist for RPFM. **Every DB TSV has a `#comment` line after the header — skip it.**
Values below marked *(proposed)* are the scout's suggested numbers/new keys, not existing rows —
verify VFX/particle/audio keys actually exist in the dump before use (they may need art, see §Art).

## Data-linking model (applies to both units)
- Artillery links its projectile via **`land_units.primary_ammo`** (a numeric index), NOT via
  `unit_missile_weapon_junctions`. Fire Rain has no missile-weapon junction row. **Open risk:**
  confirm whether `primary_ammo` is a row-id or key index once cloned in RPFM — test it fires.
- Chain: `main_units → land_units(.primary_ammo) → projectiles → {projectile_displays,
  projectiles_explosions}`. Model/crew via `unit_variants`. Recruit via
  `units_to_groupings_military_permissions` + `building_units_allowed`. Name via
  `text/db/land_units__.loc.tsv` (`land_units_onscreen_name_<key>`).
- **Knockback lives in `projectiles_explosions.detonation_force`** (Fire Rain 200, Empire Mortar
  260). Secondary: `projectiles.shockwave_radius`. No `contact_stat_effect` on Fire Rain.

---
## UNIT 1 — Cathay "Dragon Rocket Battery" (thunderclap mortar, upgunned)
Decisions: chassis = Fire Rain; **graft Empire Mortar projectile**; upgun + dragon-fire reskin.

- **Chassis to clone:** `wh3_main_cth_art_fire_rain_rocket_battery_0` (main_units, tier 3, cost
  1100/300). Crew `wh3_main_cth_artillery_crew`, engine `wh3_main_cth_art_fire_rain_rocket_battery`.
- **Donor projectile (chosen): Empire Mortar** `wh2_dlc11_cst_mortar_shell`
  → explosion `wh_main_emp_mortar_explosion` → display `wh_mortar_cannonball`. (Chosen over Dwarf
  Grudge Thrower = too AP/monstrous-impact, and Chaos Dwarf Dreadquake = tier-5/Chaos VFX baggage.)
- **Thunderclap tuning (proposed):** `projectile_number`=1, `damage` 63→120-140, `ap_damage`
  27→80-100, `shockwave_radius` 0.4→1.0-1.5, slower `muzzle_velocity`; explosion
  `detonation_radius` 6→8-10, `detonation_damage` 49→100-120, **`detonation_force` 200→300-400**
  (the thunderclap knock).
- **Reskin (needs assets, see §Art):** new `projectile_display` + `projectiles_explosions` rows
  with dragon-fire particle/trail/audio.

### Clone checklist
| Table | Action | Key / change |
|---|---|---|
| main_units | clone Fire Rain | `wh3_main_cth_art_dragon_rocket_battery_0`, tier 4, cost ~1400/350 |
| land_units | clone Fire Rain | same key; `primary_ammo`→new dragon projectile; keep crew/engine |
| projectiles | clone Empire Mortar shell | `wh3_main_cth_dragon_rocket`; upgun; swap display+explosion |
| projectiles_explosions | clone mortar explosion | `wh3_main_cth_dragon_fireball_explosion`; force 350 |
| projectile_displays | clone mortar display | `wh3_main_cth_dragon_fireball`; dragon model+trail |
| unit_variants | copy as-is | unit=new key, variant=`wh3_main_cth_artillery_crew` |
| units_to_groupings_military_permissions | +2 rows | groups `wh3_main_cth`, `wh3_cp1_group_cth_bhashiva` |
| building_units_allowed | +1 row | building `wh3_main_cth_gunners_3` |
| land_units__.loc | +1 row | `land_units_onscreen_name_...` = "Dragon Rocket Battery" |

---
## UNIT 2 — Kairos/Tzeentch "Bloated Horror Launcher"
Tzeentch has **no base-roster artillery** (confirmed). Decisions: chassis = Dwarf Grudge Thrower
(compact lobber); projectile = pink-horror blob; "random magic on landing" = **Tier1+Tier2**.

- **Chassis (chosen): Dwarf Grudge Thrower** `wh_main_dwf_art_grudge_thrower` — lob arc + compact
  launcher reads more daemonic than Empire mortar; stone→pink-orb is an easy reskin. (Fallback:
  Empire Mortar for a simpler arc.)
- **Projectile look:** try Pink Horror **unit entity as projectile display**
  (`wh3_main_tze_daemon_pink_horror_04`) — precedent: Casket of Souls displays an entity. Fallback:
  reskinned sphere with pink VFX.

### "Random magic on landing" — feasibility (ranked)
- **T1 EASIEST ✓** fixed magic contact effect. `projectiles.contact_stat_effect` (precedent: Skaven
  poison-wind mortar `contact_stat_effect=wh2_dlc14_unit_contact_poisoned_wind`) + magical explosion.
- **T2 MODERATE ✓** **vortex spawn on impact** — real precedent found: `wh3_dlc25_emp_deathstorm_morr_rocket`
  has `projectiles.spawned_vortex=...`. So a projectile CAN spawn a vortex (this overturns the earlier
  "0 vortex links" worry). Add a `battle_vortexs` row for a short random magic swirl.
- **T3 HARD ✗** multiple random effects via contact chain — no "random" template in
  `special_ability_contact_phase_groups`. Would need new tables.
- **T4 VERY HARD ✗** true random *spell* cast on impact — no blueprint linking spells to impacts.
- **T5 RESEARCH ✗** Pink→Blue Horror split on landing — split is a unit *ability*, no
  "summon unit on projectile impact" table exists. Defer.
- **Recommended v1:** T1 (fixed pink magic blast) **+** T2 (spawn one short-lived magic vortex) =
  reads as chaotic/random, uses only existing tables, no blockers.

### Clone checklist
| Table | Action | Key / change |
|---|---|---|
| main_units | clone Grudge Thrower | `wh3_main_tze_art_bloated_horror_launcher_0`, tier 2, ~900/225 |
| land_units | clone Grudge Thrower | crew→Tzeentch daemon; `primary_ammo`→new; class `art_fld` |
| projectiles | clone grudge stone | `wh3_main_tze_bloated_horror`; ap-heavy(magic); `contact_stat_effect`+`spawned_vortex` |
| projectiles_explosions | clone | `..._explosion`; `is_magical`=true; pink particle |
| projectile_displays | clone | `..._display`; pink-horror entity or reskinned orb |
| battle_vortexs | +1 row | `wh3_main_tze_random_magic_vortex`; dur ~4s, magical, force ~150 |
| unit_variants | clone | Tzeentch crew variant |
| units_to_groupings_military_permissions | +2 rows | `wh3_main_tze`, `wh3_main_dae` |
| building_units_allowed | +1 row | a Tzeentch tier-≤2 building (find via table) |
| land_units__.loc | +1 row | "Bloated Horror Launcher" |

---
## Confirmed blockers / risks
1. **True random spell / unit-summon on impact** = no template (T4/T5). Post-v1 only.
2. **`primary_ammo` link** is a numeric index — verify the clone actually fires in RPFM.
3. **New VFX/particle/audio/model keys are proposed, not confirmed to exist** — see §Art.

## §Art — where this meets the 3D/asset question
The DB clone is fully doable from this dump. But the *look* (dragon-fire explosion particle,
dragon fireball projectile model, pink-horror blob) depends on assets that either (a) already exist
and can be reused, or (b) must be made. Before assuming a proposed VFX key exists, grep the dump /
game packs. Options per the earlier discussion: **reuse an existing pink/fire explosion**, **kitbash**
existing meshes (text-side, agent-doable), or **new 3D** (Blender-MCP-drivable for a static machine +
reused crew anim; needs the rmv2 export step). v1 recommendation: ship on **reused/kitbashed assets**,
treat bespoke dragon/horror models as a later art pass.
