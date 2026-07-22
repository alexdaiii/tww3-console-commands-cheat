# HANDOFF — TWW3 Kairos modding kit

For the next Claude picking this up. Read this first, then the files it points to.

## What the user is doing
Modding **Total War: Warhammer 3** via a Steam Workshop "run arbitrary Lua" console mod.
The mod exposes two console commands:
- `item <ancillary_id>`  → grants/equips an item (items = "ancillaries" in the DB).
- (traits are applied by running generated Lua that calls `cm:force_add_trait`).

Currently playing **Kairos Fateweaver** (Tzeentch Legendary Lord — flying Lord of Change,
caster-monster). Goal: make his lord + army absurdly strong regardless of troop quality,
by stacking traits and a curated item loadout.

## Standing constraints (do NOT violate)
- **Corruption traits stay OUT** of the trait set for now (user's explicit call).
- **Prologue traits are KEPT** — they work in the main campaign via `force_add_trait`
  (e.g. "Saviour"). Only `dummy` keys are excluded in curate_traits.py. Do not re-add a
  blanket "prologue" exclusion; the user corrected me on this.

## The toolchain (all in this dir: tww3_traits/)
Data source: **WH3-Dump/** — a local TSV clone of the game DB. Every table is at
`WH3-Dump/db/<table>_tables/data__.tsv`. NOTE: each file has a `#comment` line right
after the header row — skip it when parsing (join_traits.py's `read_tsv` already handles this).

### Traits pipeline
- `join_traits.py` — joins character_traits + trait_levels + effects + loc into a readable
  sheet. Provides reusable helpers: `read_tsv`, `read_loc`, `render_effect`, `clean_text`,
  `game_and_dlc`.
- `curate_traits.py` — filters/curates the "power" traits and buckets them by target area
  (survivability / attack / army / economy / **diplomacy**). Outputs `power_traits.xlsx` +
  `power_traits.lua`. Current result: **306 traits** (39 survivability, 60 attack, 149 army,
  36 economy, 22 diplomacy).
  Key logic quirks (bugs I fixed — don't reintroduce):
    * **`FORCE_INCLUDE`** = explicit allow-list (16 keys) the user hand-picked off the
      `excluded_traits.xlsx` bench: battle abilities (poison / Glacial Blast / Ice Shard),
      attrition, wound recovery, and the campaign agent/hero-map action traits. Their effects
      render as unreadable "other" text so keywords can't catch them; each maps to a bucket
      and is promoted after the harm filters. Deliberately NOT keyworded (a broad `ability`
      rule would sweep in un-picked siblings like Deadly Onslaught / Heroic Resilience).
      NOTE for the user: the 7 `agent_action_*` + `grandfathers_embrace`/`quiet_warrior`/
      `agent_of_brutality` buff AGENT/hero actions — **near-useless on Kairos (a Lord)**;
      kept because the user asked. The abilities/attrition/wound-recovery ones ARE useful.
    * **Fear/Terror & spell cooldown are power effects.** `causes fear`/`causes terror` (the
      "Hates X" / defeated-legend attributes, value +1 = granted to us) and `cooldown` are in
      ATTACK_KW. Cooldown is INVERTED: negative value = shorter = good; a POSITIVE cooldown is
      a self-debuff, guarded explicitly in main() (HARM_STATS can't express the sign flip).
    * **Public order is scope-dependent.** `character_to_enemy_province` negatives (e.g.
      `post_battle_execute`, `stance_raiding`, `defeated_drycha/skrolk`) LOWER the enemy's
      order = a buff to us → kept (bucket "army" via the `"enemy" in scope` rule in bucket()).
      `character_to_province_own` negatives (`realm_khorne` −10, `corrupted_*`) are self-harm
      → still dropped by is_unwanted (now takes a `scope` arg). Positive own-province order
      (`Authoritarian` etc.) classifies as Economy — ECON_KW includes the un-spaced loc token
      `public_order` because `{{tr:public_order_effect}}` doesn't resolve to "public order".
    * **Points = `threshold_points`, NOT the level number.** `force_add_trait`'s 4th arg is
      trait POINTS; a trait reaches a level only when points cross that level's
      `threshold_points` (in `character_trait_levels`). Master Mason lvl 3 needs 15 points,
      not 3; the 1-level "wins vs Lizardmen" needs 5, not 1. We now pass the TOP level's
      threshold_points so traits apply at max rank instead of sitting sub-rank-1 and
      re-"popping up" during play. (`top_threshold` in main().)
    * **Diplomacy traits are kept.** The +relations "reinforcing_*"/"Likes X" traits (e.g.
      `wh2_main_trait_reinforcing_beastmen`, +10 diplo) used to bucket to "other" and get
      dropped by the "must contribute" gate. Added a DIPLO_KW / "diplo" bucket / "Diplomacy"
      category. Only POSITIVE diplo survives — `is_unwanted()` still drops any diplo effect
      carrying a negative number (mixed +/- traits).
    * Enemy-debuff guard: `"enemy" not in low` before treating a `"leadership: -"` effect as
      self-harm (else beneficial enemy-morale debuffs get wrongly dropped).
    * `bucket()`: effects with "enemy"/aura/force-scope → "army"; leadership/vigour/morale
      are in SURVIVE_KW so they classify instead of vanishing.
    * Exclude only keys containing `"dummy"`. Keep prologue traits.
    * Genuinely effect-less flavour traits (34 of them: top level AND every lower level have
      no `trait_level_effects` rows) are correctly excluded — not a bug.
- `make_apply_lua.py` — turns a trait-id list into apply-Lua (uses `cm:force_add_trait` via
  `cm:char_lookup_str`). Convention twin of make_apply_items_lua.py.
- `excluded_traits.py` — the INVERSE of curate: writes `excluded_traits.xlsx` listing every
  trait NOT in the power set, tagged with the first rule that dropped it (hidden → dummy →
  DLC-locked → no-effects → self-debuff → corruption → bundled downside → off-target).
  Imports curate_traits' helpers so the two never drift. "off-target" = traits whose only
  effects are unrecognised by the bucketer — the review queue for what to promote next
  (this is how diplomacy, Fear, and cooldown got pulled in). ~31 remain (ability grants like
  Deadly Onslaught/Glacial Blast, Stalk/Vanguard attributes, poison attacks, hero-map utility).

### Items pipeline
- `make_apply_items_lua.py` — turns a `<kit>.txt` list of ancillary ids into `<kit>.lua`.
  Run: `python3 make_apply_items_lua.py kairos` → reads `kairos.txt`, writes `kairos.lua`,
  prints a per-item summary + slot warnings from `items.xlsx`.
  Uses `cm:force_add_ancillary(character, key, force_equip, suppress)` — same effect as the
  mod's `item <id>`, bypassing faction/slot/uniqueness rules. Switches: `--apply-to
  character|faction`, `--pool` (add to pool unequipped), `--no-equip`.
- `items.xlsx` — the item catalog (id/name/category/subcategory/rarity/faction/effects).
- `kairos.txt` / `kairos.lua` — Kairos's current loadout (the deliverable).

### Units / army pipeline  (added this session)
- `make_units.py` — turns a CSV army list into per-army "add units" Lua. Run:
  `agent-venv/bin/python make_units.py kairos.csv` (see venv gotcha below — do NOT
  use `uv run`). CSV columns: `unit_id,num_units,army_name[,note]`. The CSV stem is
  the general name; each distinct `army_name` writes `<general>_<army_name>.lua`
  (e.g. `kairos_late.lua`). Stdlib-only (csv/os/re) — no pandas/openpyxl needed.
  Annotates each unit with its onscreen name from `WH3-Dump/text/db/land_units__.loc.tsv`
  and warns if an army exceeds the 19-unit cap.
    * `unit_id` = a **main_units** key (same key the mod's `au <unit> <amount>` takes).
    * Generated Lua adds units via `cm:grant_unit_to_character(cm:char_lookup_str(char),
      key)` looped `num_units` times — the scripted/batched form of `au`, bypassing
      recruitment + caps (so you can stack RoR past their normal cap-of-1).
    * Known cosmetic miss: `wh3_main_tze_mon_exalted_flamers_0` (plural) has no loc name
      because the loc key is `..._flamer_0` (singular). unit_id is correct; only the
      comment is blank. Fix would need the `main_units.land_unit` mapping — user said skip.
- `kairos.csv` — the deliverable army lists (early / mid / late), see below.

### Kairos army compositions (base game WH3 only, no DLC; `au`-ready)
Design rule the user set: **tier is a per-stage power CEILING** (so you don't stomp
early-campaign AI with top units), not a floor — build the best army under the cap.
Full stack = Kairos (lord) + **19** units. Tzeentch is a magic/ranged gunline: ranged
core (armour-ignoring magical fire) + thin melee screen + flyers for artillery/anti-large.
- **Early (≤ T2):** 5 Forsaken (screen), 6 Pink Horrors, 3 Chaos Furies, 5 Flamers. (user reroll)
- **Mid (T3/4):** 4 Chaos Warriors of Tzeentch (Halberds, `wh3_dlc20_..._mtze_halberds`, free-DLC),
  6 Blazing Squealers (Exalted Pink Horrors RoR, `wh3_twa06_..._pink_horrors_ror_0`),
  2 Wyrd Spawn (Chaos Spawn RoR, `wh_pro04_chs_mon_chaos_spawn_ror_0`), 5 Exalted Flamers,
  2 Knights of Immolation (Doom Knights RoR, `wh3_twa07_..._doom_knights_ror_0`). (user reroll)
- **Late (elite):** 3 Chaos Warriors of Tzeentch (Halberds, melee frontline/anchor —
  armour 100 + anti-large is the gunline's main screen vs cav/monsters),
  1 Wyrd Spawn (Chaos Spawn RoR, infantry-grinder/fear tarpit — kept 1, not 2, since 4 Soul
  Grinders + halberds already anchor and spawn are armour-10 squishy),
  4 Blazing Squealers (Exalted Pink Horrors RoR),
  4 Exalted Flamers, 4 Soul Grinder, 1 Golden Griffin of Theurgy (Lord of Change RoR),
  2 Knights of Immolation (Doom Knights RoR). (user rerolls: added a melee line vs the old
  pure-gunline 9-Flamer stack; now includes T2 halberds/spawn, dropping the old "NO T2" rule;
  then cut Griffins 3→1 and bumped Flamers/Grinders to 4 each to reduce manual-cast micro —
  Griffin bound spells (Searing Doom / Gehenna's Golden Hounds) are manual-only, Flamers &
  Grinders auto-fire their ranged attacks.)
Heroes: `au` adds army *units*, not characters — embed real casters (Exalted Lord of
Change, Iridescent Horror) the normal way; each eats 1 of the 19 slots. 3–4 casters
(incl. Kairos) = magic-overwhelm build.

### Slot model
- Equipment (weapon/armour/talisman/arcane item/enchanted item/mount) = **1 slot each**.
- Followers + banners (xlsx category "General") share **5 ancillary slots**.

## Kairos's current loadout (kairos.txt)
Equipment: Scintillating Shield (Barrier), Forbidden Rod (spell intensity), Book of Secrets
(WoM cost), Sapphire Guardian Phoenix (spell res 45%), Staff of Change (WoM + corruption).
5 ancillaries: Personal Sycophant, Dark Prince's Paramour, Sorcerer's Apprentice,
Icon of Sorcery (banner), Tzeentchian Philosopher (LOCAL region only).
Commented alts in file: alchemist, agent_of_change, banner_of_change, great_icon_of_despair.

## Key facts established (so you don't re-derive them)
- **Kairos base stats** (from land_units/battle_entities tables): HP ~8,040; Leadership 85;
  Armour 50 (`wh2_main_body_50`); MA 35; MD 20 (his one weak base stat); charge 20;
  mass 3,500 (giant, flying); innate ~20% physical resist. Unit key
  `wh3_main_tze_cha_kairos_fateweaver_0`.
- **Buffed totals** (base + traits + kit): HP ~12,000 (+2,000 barrier, +regen); armour ~120;
  MD ~91; MA ~85; charge ~115; leadership ~124 (+ Unbreakable); phys resist ~60% (+ward 20%);
  spell res capped 90%; fire res 50%.
- **Effective HP to kill him**: ~70k gross AP-physical (80% mitigation on ~14k pool),
  ~140k vs magic, ~47k vs fire. Realistic threat = 3–5 AP anti-large units focus-firing, or
  a massed AP gunline pinning him — and he can fly away. Effectively unkillable otherwise.
- **API signatures**: `cm:force_add_ancillary(char_obj, key, force_equip, suppress)`;
  `cm:add_ancillary_to_faction(faction, key, suppress)`; `cm:force_add_trait(lookup_str,
  trait_id, show_message, points)`.
- **Undead & Daemons** are unbreakable → all -leadership effects do nothing to them; must be
  beaten by damage (magical attacks, Bonus vs Large, spells).
- **Banners buff the BEARER unit**, not the whole army (except explicitly army-wide ones).
  Banner of Eternal Flame / Banner of Hellfire = flaming attacks on the bearer.
- **Unit tiers:** `main_units.tier` in the dump = recruitment/building tier. Heroes/lords
  are tier 0. The base Tzeentch roster tops at tier 4 in the dump EXCEPT the Lord of Change
  (+Golden Griffin RoR), which the dump mislabels tier 4 but the live game shows as **tier 5**
  — its greater-daemon peers (Bloodthirster, Great Unclean One, Keeper of Secrets) ARE tier 5
  in the same dump, so trust the in-game card: Lord of Change = the Tzeentch tier-5 apex.
  All 106 "clean" tier-5 units otherwise are DLC (Star Dragons, Hell Pit Abomination, etc.).
- **Tzeentch sieges:** no siege equipment needed — much of the roster flies (Kairos, Lord of
  Change/Golden Griffin, Screamers, Chaos Furies, Burning Chariot) or is a Siege Attacker
  monster (Soul Grinder, Flamers, Lord of Change). Foot troops (Pink/Blue Horrors, Forsaken)
  and cavalry can't scale walls — fly a gate open for them. Tzeentch has NO artillery;
  Exalted Flamers (arcing magical fire) are the stand-in.

## Pending / open threads
1. **Banner of Hellfire** as a commented alt in kairos.txt + confirm whether Kairos has
   Lore of Fire (for Flaming Sword of Rhuin) — offered, not yet done.
2. **Per-faction item kits** (Tzeentch, Cathay, etc.) using the same generator — standing
   future request; "focus on kairos for now" was the last word.
3. Item usability filter for other factions: usable if faction blank/all, "all except X"
   not excluding the target faction, or contains the faction name; character-lock must be empty.
4. **Army pipeline is delivered** (`make_units.py` + `kairos.csv`, 3 armies generated & sanity-
   checked). Standing future options the user has NOT asked for yet: per-faction army CSVs
   (Cathay etc. — `make_units.py <faction>.csv` already supports it), a monster-heavy late
   variant (5–6 Golden Griffins), and a `siege`/`fly` flag column on units. User declined the
   Exalted Flamers name-annotation fix — leave it.

## Gotchas
- **venv/uv (user's hard rule):** NEVER touch the user's `.venv`. Use uv + a separate
  `agent-venv` (at repo root: `/home/ac4294/Documents/dev/2026/cppd-crystal/agent-venv`).
  Do NOT run `uv run --project`, bare `uv run`, or `uv sync` in this repo — uv treats the
  project `.venv` as managed and will **delete + recreate it** (this happened once). To run
  a script, call the interpreter directly: `agent-venv/bin/python make_units.py kairos.csv`.
  For deps: `uv pip install --python agent-venv/bin/python <pkg>` then run the interpreter
  directly. The `tww3_traits` scripts that need xlsx (join_*/curate/make_apply_items) use
  openpyxl — install it into agent-venv; `make_units.py` is stdlib-only.
- WH3-Dump TSVs have that `#comment` second line — always skip it.
