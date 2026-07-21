# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Two unrelated projects live here

This directory is named `cppd-crystal` but hosts **two independent efforts** that share no code.
Identify which one a request is about before acting:

1. **CPPD crystal / BoltzGen peptide binder design** (the nominal project). Currently
   research-only — see `notes/`. No implementation code exists yet; `main.py` is the uv
   template placeholder.
2. **`tww3_traits/` — Total War: Warhammer 3 modding kit** (the only substantive code).
   Self-contained; unrelated to CPPD. Has its own `HANDOFF.md` — **read it first** before
   touching anything under `tww3_traits/`.

The root Python package (`pyproject.toml`, `main.py`, `uv.lock`) belongs to project (1) but is
an empty scaffold; the actual `tww3_traits/` scripts are run standalone with system Python, not
via this package.

## Project 1 — CPPD peptide binder (research stage)

Goal: design peptide binders against calcium pyrophosphate dihydrate (CPPD) crystals — the
pseudogout crystal — using BoltzGen. Two disease-relevant polymorphs: **t-CPPD** (triclinic, P1̄)
and **m-CPPD** (monoclinic, P2₁/n); m-CPPD is the more inflammatory acute-flare form.

- `notes/CPPD_crystal_structure_notes.md` — the primary knowledge base: polymorph structures,
  CIF sources (IUCr/COD, from Gras 2016 and Mandel 1975), validated inflammation mechanism
  (NLRP3-dependent; surface area is **not** the driver), and two candidate BoltzGen strategies
  (A: crystal-growth-face inhibitor — considered more tractable; B: anti-inflammatory surface coat).
- `notes/references.bib` — BibTeX for all cited papers (Zotero-importable).

When extending this project, ground claims in the notes' cited papers rather than general priors;
the notes explicitly flag which common assumptions the literature contradicts.

Tooling: Python ≥3.14 managed by **uv**. `uv sync` to install, `uv run main.py` to run.

## Project 2 — `tww3_traits/` TWW3 modding kit

`tww3_traits/HANDOFF.md` is the authoritative context (game state, constraints, established
facts, open threads). This section covers only the architecture; do not duplicate HANDOFF here.

### What it produces
Python scripts read the game's database (a local TSV dump) and emit **Lua scripts** that are
pasted into a Steam Workshop "run arbitrary Lua" console mod to grant traits and items to
characters in-game via `cm:force_add_trait` / `cm:force_add_ancillary`.

### Data source
`tww3_traits/WH3-Dump/` — a local clone of the game DB. Each table lives at
`WH3-Dump/db/<table>_tables/data__.tsv`; localized text at `WH3-Dump/text/db/*.loc.tsv`.
**Every DB TSV has a `#comment` line immediately after the header — skip it when parsing.**
`join_traits.py`'s `read_tsv` already handles this; reuse it rather than re-parsing.

### Two pipelines, mirror-image conventions
**Traits:**
- `join_traits.py` — joins character_traits + trait_levels + effects + loc into a readable sheet.
  Exports the reusable helpers (`read_tsv`, `read_loc`, `render_effect`, `clean_text`,
  `game_and_dlc`) that every other trait script imports as `import join_traits as J`.
- `curate_traits.py` — filters to beneficial base-game traits and buckets them
  (survivability / attack / army / economy); writes `power_traits.xlsx` + `power_traits.lua`.
  Contains deliberate classification fixes documented in HANDOFF — do not reintroduce the bugs.
- `make_apply_lua.py` — turns a trait-id list into apply-Lua.

**Items** (twin of the trait pipeline):
- `join_items.py` — builds `items.xlsx` catalog from the ancillaries tables.
- `make_apply_items_lua.py` — turns a `<kit>.txt` id list into `<kit>.lua`, e.g.
  `python3 make_apply_items_lua.py kairos` reads `kairos.txt`, writes `kairos.lua`.

`kairos.txt` / `kairos.lua` are the current deliverable (Kairos Fateweaver loadout).
`apply_traits.lua` / `apply_selected_traits.lua` / `apply_selected_items.lua` are hand-editable
console scripts (edit the `TRAITS`/config block at the top).

### Running the kit
Standalone system Python 3, not the uv package. openpyxl is required:
`pip install --break-system-packages openpyxl`. Run scripts from inside `tww3_traits/` so the
relative `WH3-Dump/` and `*.xlsx` paths resolve.
