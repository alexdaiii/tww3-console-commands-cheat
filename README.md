# cppd-crystal

This repo hosts two unrelated efforts (see `CLAUDE.md`):

1. **CPPD crystal / BoltzGen peptide binder design** — research-only, see `notes/`.
2. **`tww3_traits/`** — Total War: Warhammer 3 modding kit. See `tww3_traits/HANDOFF.md`.

## Do not commit `wh3.sqlite`

`tww3_traits/wh3.sqlite` (~140 MB) is a **generated** SQLite mirror of the game DB, built
locally by `tww3_traits/build_db.py` from `WH3-Dump/`. It is large and fully rebuildable, so
it is **git-ignored** (`*.sqlite` in `.gitignore`) and must never be committed.

Rebuild it any time with:

```bash
cd tww3_traits
python3 build_db.py
```

### If you accidentally staged or committed it

```bash
# Staged but not yet committed — just unstage it:
git rm --cached tww3_traits/wh3.sqlite

# Already committed — remove it from the last commit (keeps the file on disk):
git rm --cached tww3_traits/wh3.sqlite
git commit --amend --no-edit

# Already in older history — purge it from all commits (rewrites history):
git filter-repo --path tww3_traits/wh3.sqlite --invert-paths
```

After any of these, confirm `.gitignore` contains `*.sqlite` so it stays out.
