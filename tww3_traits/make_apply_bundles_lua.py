#!/usr/bin/env python3
"""
make_apply_bundles_lua.py  -  Turn a list of effect_bundle ids into an
                              apply-to-army Lua script for the TWW3 "run lua" mod.

The DEFENSIVE/army-buff twin of the trait/item/skill generators. A trait or item
grants effects to ONE character; an effect_bundle can carry FORCE-scope effects
(e.g. "+15 melee defence to every unit in the army"). The console mod can't mint
a NEW bundle (that needs a .pack DB mod), but it can APPLY an existing one to a
force via the CA campaign API:

    cm:apply_effect_bundle_to_force(effect_bundle_key, military_force_cqi, turns)

So this script reads a curated list of existing bundle keys and stacks them onto
the selected lord's army. Pick bundles whose effects are FORCE-scope and positive
(see all_effects.xlsx / the wh3.sqlite mirror to vet a bundle's full contents
before adding it - some carry side effects).

Workflow
--------
1. Put one effect_bundle id per line in <kit>/<kit>_defence.txt (blank lines and
   #comments skipped; inline "id   # note" is fine).

2. Generate the Lua:
       python3 make_apply_bundles_lua.py kairos
   -> reads kairos/kairos_defence.txt, writes kairos/kairos_defence.lua, and
      prints each bundle's title + effect breakdown pulled from WH3-Dump.
   (With no name it falls back to bundles.txt -> apply_selected_bundles.lua.)

Options
  --txt PATH      id list to read              (default: <kit>/<kit>_defence.txt)
  --dump PATH     WH3-Dump dir for annotations (default: ./WH3-Dump)
  --out PATH      Lua file to write            (default: <kit>/<kit>_defence.lua)
  --turns N       default TURNS value baked into the Lua (0 = permanent)
  --apply-to      character | faction          (default: character)
"""
from __future__ import annotations
import argparse
import os
import re
from collections import OrderedDict

import join_traits as J  # reuse read_tsv / read_loc / clean_text / fmt_number

HERE = os.path.dirname(os.path.abspath(__file__))

# Register the tables this script needs on J's file map (paths are relative to
# the WH3-Dump repo root, which J.read_tsv joins against J.REPO).
J.FILES["bundle_jct"] = "db/effect_bundles_to_effects_junctions_tables/data__.tsv"
J.FILES.setdefault("effects_loc", "text/db/effects__.loc.tsv")
J.FILES["bundles_loc"] = "text/db/effect_bundles__.loc.tsv"


# --------------------------------------------------------------------------
def read_ids(path: str):
    """Return list of (id, inline_note) from the txt file, order preserved."""
    ids = []
    with open(path, encoding="utf-8") as f:
        for raw in f:
            line = raw.rstrip("\n")
            if not line.strip() or line.lstrip().startswith("#"):
                continue
            note = ""
            if "#" in line:
                line, note = line.split("#", 1)
                note = note.strip()
            key = line.strip()
            if key:
                ids.append((key, note))
    return ids


def _readable(effect_loc: dict, effect: str, value: str) -> str:
    """The effect's loc template with the value substituted, e.g. '+15 Melee Defence'."""
    tmpl = effect_loc.get(f"effects_description_{effect}")
    if not tmpl:
        return effect  # no loc -> show the raw key
    signed, _, _ = J.fmt_number(value)
    plain = signed.lstrip("+")
    shown = tmpl.replace("%+n", signed).replace("%n", plain).replace("%%", "%")
    return J.clean_text(shown)


def annotate(bundle_keys, dump_dir: str):
    """bundle_key -> {'title': str, 'effects': [readable, ...]}. Best-effort."""
    # Point J at the requested dump (its module global REPO otherwise picks up
    # sys.argv[1], which for THIS script is the kit name, not a repo path).
    J.REPO = dump_dir
    info = {k: {"title": "", "effects": []} for k in bundle_keys}
    try:
        bundles_loc = J.read_loc("bundles_loc")
        effects_loc = J.read_loc("effects_loc")
    except (OSError, KeyError):
        return info
    wanted = set(bundle_keys)
    per_bundle: dict[str, list] = {}
    for r in J.read_tsv("bundle_jct"):
        bk = r.get("effect_bundle_key", "")
        if bk in wanted:
            per_bundle.setdefault(bk, []).append(
                (r.get("effect_key", ""), r.get("effect_scope", ""), r.get("value", "")))
    for bk in bundle_keys:
        title = bundles_loc.get(f"effect_bundles_localised_title_{bk}", "")
        title = "" if (not title or title.startswith("{{") or title == "HIDDEN") else J.clean_text(title)
        info[bk]["title"] = title
        info[bk]["effects"] = [
            {"text": _readable(effects_loc, ek, v), "scope": scope}
            for ek, scope, v in per_bundle.get(bk, [])
        ]
    return info


_NUM = re.compile(r"[+-]?\d+(?:\.\d+)?")


def sum_effects(all_effects):
    """Sum numeric effects that share a label (e.g. three '+15 melee defence' -> +45);
    count repeated non-numeric ones. all_effects: list of {'text','scope'}."""
    numeric: "OrderedDict[str, float]" = OrderedDict()   # signature -> summed value
    flat: "OrderedDict[str, int]" = OrderedDict()         # text -> count
    for e in all_effects:
        t = e["text"]
        m = _NUM.search(t)
        if m:
            val = float(m.group())
            sig = t[:m.start()] + "{n}" + t[m.end():]
            numeric[sig] = numeric.get(sig, 0.0) + val
        else:
            flat[t] = flat.get(t, 0) + 1
    lines = []
    for sig, val in numeric.items():
        a = int(val) if val == int(val) else round(val, 2)
        lines.append(sig.replace("{n}", ("+" if val >= 0 else "") + str(a)))
    for t, n in flat.items():
        lines.append(t + (f"  (x{n})" if n > 1 else ""))
    return lines


# --------------------------------------------------------------------------
LUA_TEMPLATE = '''--------------------------------------------------------------------------------
-- {out_name}
-- Auto-generated by make_apply_bundles_lua.py.
-- Effect bundles: {n}   Default duration: {turns_label}
--
-- Run via the TWW3 "run arbitrary lua" console mod. Applies each effect bundle
-- below to the SELECTED lord's ARMY (or the faction leader's) via
--     cm:apply_effect_bundle_to_force(bundle_key, military_force_cqi, TURNS)
-- Bundles carry FORCE-scope effects, so these buff every unit in the army.
--
-- Combined army-wide effect of this set:
{effects_comment}
--------------------------------------------------------------------------------

local APPLY_TO = "{apply_to}"   -- "character" (selected) or "faction" (leader)
local TURNS    = {turns}            -- 0 = permanent (until removed); >0 = lasts N turns

-- effect_bundle ids to apply to the army
local BUNDLES = {{
{bundle_lines}
}}

local cm = get_cm and get_cm() or cm
local function log(m) if out then out(m) else print(m) end end

local function get_selected_character()
    local ui = cm:get_campaign_ui_manager()
    local cqi = ui and ui:get_char_selected_cqi()
    if cqi and cqi ~= 0 then return cm:get_character_by_cqi(cqi) end
    return nil
end

local function get_faction_leader()
    local faction = cm:get_local_faction(true) or cm:get_local_faction()
    if not faction or faction:is_null_interface() then return nil end
    local leader = faction:faction_leader()
    if leader and not leader:is_null_interface() then return leader end
    return nil
end

local function run()
    local target = (APPLY_TO == "faction") and get_faction_leader() or get_selected_character()
    if not target or target:is_null_interface() then
        log("apply_bundles: ERROR - no valid target (" .. APPLY_TO .. "). Select a character first.")
        return
    end
    local mf = target:military_force()
    if not mf or mf:is_null_interface() then
        log("apply_bundles: ERROR - target has no army (embedded hero? garrisoned?). Select a lord with a force.")
        return
    end
    local force_cqi = mf:command_queue_index()
    local added = 0
    for _, key in ipairs(BUNDLES) do
        if key and key ~= "" then
            cm:apply_effect_bundle_to_force(key, force_cqi, TURNS)
            added = added + 1
            log("apply_bundles: applied '" .. tostring(key) .. "' to force " .. tostring(force_cqi))
        end
    end
    log("apply_bundles: done - " .. tostring(added) .. " bundle(s) applied for " ..
        (TURNS == 0 and "permanent" or (tostring(TURNS) .. " turns")) .. ".")
end

run()
'''


def build_lua(ids, info, out_name, apply_to, turns):
    lines = []
    combined = []
    for key, note in ids:
        meta = info.get(key, {})
        label = meta.get("title") or note
        comment = f"  -- {label}" if label else ""
        lines.append(f'    "{key}",{comment}')
        combined.extend(meta.get("effects", []))
    summed = sum_effects(combined)
    effects_comment = "\n".join(f"--   * {e}" for e in summed) or "--   (none resolved from dump)"
    turns_label = "permanent" if turns == 0 else f"{turns} turns"
    return LUA_TEMPLATE.format(
        out_name=out_name, n=len(ids), turns=turns, turns_label=turns_label,
        apply_to=apply_to, effects_comment=effects_comment,
        bundle_lines="\n".join(lines),
    )


def main():
    ap = argparse.ArgumentParser(
        description="ids in <kit>_defence.txt -> <kit>_defence.lua apply-to-army Lua.")
    ap.add_argument("name", nargs="?",
                    help="Kit name: reads <name>/<name>_defence.txt, writes <name>_defence.lua (e.g. kairos).")
    ap.add_argument("--txt", help="Explicit id list to read (overrides the default).")
    ap.add_argument("--dump", default=os.path.join(HERE, "WH3-Dump"),
                    help="WH3-Dump dir for title/effect annotations.")
    ap.add_argument("--out", help="Explicit Lua file to write (overrides the default).")
    ap.add_argument("--turns", type=int, default=0, help="Default TURNS baked into the Lua (0 = permanent).")
    ap.add_argument("--apply-to", choices=["character", "faction"], default="character")
    args = ap.parse_args()

    base = args.name or "bundles"
    if base == "bundles":
        txt_path = args.txt or os.path.join(HERE, "bundles.txt")
        out_path = args.out or os.path.join(HERE, "apply_selected_bundles.lua")
    else:
        kit_dir = os.path.join(HERE, base)
        os.makedirs(kit_dir, exist_ok=True)
        default_txt = os.path.join(kit_dir, f"{base}_defence.txt")
        if not args.txt and not os.path.exists(default_txt):
            legacy = os.path.join(HERE, f"{base}_defence.txt")
            if os.path.exists(legacy):
                default_txt = legacy
        txt_path = args.txt or default_txt
        out_path = args.out or os.path.join(kit_dir, f"{base}_defence.lua")

    if not os.path.exists(txt_path):
        raise SystemExit(f"No id list at {txt_path}. Create it (one effect_bundle id per line).")

    ids = read_ids(txt_path)
    if not ids:
        raise SystemExit(f"No ids found in {txt_path}. Add one effect_bundle id per line.")

    info = annotate([k for k, _ in ids], args.dump)
    lua = build_lua(ids, info, os.path.basename(out_path), args.apply_to, args.turns)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(lua)

    # ---- printed summary ----
    print(f"Read {len(ids)} bundle id(s) from {os.path.relpath(txt_path, HERE)}:\n")
    all_effects = []
    for key, note in ids:
        meta = info.get(key, {})
        title = meta.get("title") or note or "(no title in dump)"
        print(f"  - {title}   [{key}]")
        for eff in meta.get("effects", []):
            print(f"       {eff['text']}  [{eff['scope']}]")
            all_effects.append(eff)
    print("\nCombined army-wide totals (stacking summed):")
    for line in sum_effects(all_effects):
        print(f"  * {line}")
    print(f"\nDuration baked in: TURNS = {args.turns} "
          f"({'permanent' if args.turns == 0 else str(args.turns) + ' turns'})")
    print(f"Wrote Lua -> {out_path}")


if __name__ == "__main__":
    main()
