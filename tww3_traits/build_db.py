#!/usr/bin/env python3
"""Load the whole WH3-Dump into a single SQLite file for ad-hoc querying.

Why: the DB is ~hundreds of TSVs that all need the same #comment-line skip and
manual joins. Mirroring them into SQLite lets us answer questions with SQL
instead of re-parsing/re-joining TSVs by hand every time.

Usage:
    python3 build_db.py                 # (re)build wh3.sqlite from WH3-Dump/
    python3 build_db.py --schema        # after building, print every table + columns
    python3 build_db.py --schema PAT    # print schema for tables matching PAT

Conventions handled automatically:
  * db/<table>_tables/data__.tsv   -> table "<table>"   (drops the _tables suffix)
      first line = header, SECOND line = CA "#comment" meta row -> skipped.
  * text/db/<name>.loc.tsv         -> table "loc_<name>" (key, text, tooltip)
Every column is stored as TEXT (the dump is untyped); cast in queries as needed.
"""
import csv, glob, os, sqlite3, sys

ROOT = os.path.dirname(os.path.abspath(__file__))
DUMP = os.path.join(ROOT, "WH3-Dump")
DB = os.path.join(ROOT, "wh3.sqlite")


def _sanitize(name: str) -> str:
    return "".join(c if c.isalnum() or c == "_" else "_" for c in name)


def _load_data_tsv(cur, path):
    table = _sanitize(os.path.basename(os.path.dirname(path)))
    if table.endswith("_tables"):
        table = table[:-len("_tables")]
    with open(path, encoding="utf-8", newline="") as f:
        reader = csv.reader(f, delimiter="\t")
        try:
            header = next(reader)
        except StopIteration:
            return None
        cols = [_sanitize(c) or f"col{i}" for i, c in enumerate(header)]
        # de-dup column names
        seen = {}
        for i, c in enumerate(cols):
            if c in seen:
                seen[c] += 1
                cols[i] = f"{c}_{seen[c]}"
            else:
                seen[c] = 0
        cur.execute(f'DROP TABLE IF EXISTS "{table}"')
        col_ddl = ",".join('"' + c + '" TEXT' for c in cols)
        cur.execute(f'CREATE TABLE "{table}" ({col_ddl})')
        rows = []
        for row in reader:
            if not row or row[0].startswith("#"):
                continue  # CA #comment meta line + blanks
            row = (row + [""] * len(cols))[:len(cols)]
            rows.append(row)
        cur.executemany(
            f'INSERT INTO "{table}" VALUES ({",".join("?" * len(cols))})', rows)
        return table, len(rows)


def _load_loc_tsv(cur, path):
    base = os.path.basename(path)
    for suf in ("__.loc.tsv", ".loc.tsv"):
        if base.endswith(suf):
            base = base[:-len(suf)]
            break
    table = "loc_" + _sanitize(base)
    cur.execute(f'DROP TABLE IF EXISTS "{table}"')
    cur.execute(f'CREATE TABLE "{table}" (key TEXT, text TEXT, tooltip TEXT)')
    rows = []
    with open(path, encoding="utf-8", newline="") as f:
        for row in csv.reader(f, delimiter="\t"):
            if not row or row[0].startswith("#") or row[0] == "key":
                continue
            row = (row + ["", "", ""])[:3]
            rows.append(row)
    cur.executemany(f'INSERT INTO "{table}" VALUES (?,?,?)', rows)
    return table, len(rows)


def build():
    if os.path.exists(DB):
        os.remove(DB)
    con = sqlite3.connect(DB)
    cur = con.cursor()
    n_tab = n_loc = 0
    for path in glob.glob(f"{DUMP}/db/*_tables/data__.tsv"):
        if _load_data_tsv(cur, path):
            n_tab += 1
    for path in glob.glob(f"{DUMP}/text/db/*.loc.tsv"):
        _load_loc_tsv(cur, path)
        n_loc += 1
    con.commit()
    con.close()
    print(f"Built {DB}\n  {n_tab} data tables, {n_loc} loc tables")


def schema(pat=None):
    con = sqlite3.connect(DB)
    cur = con.cursor()
    tabs = [r[0] for r in cur.execute(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")]
    for t in tabs:
        if pat and pat.lower() not in t.lower():
            continue
        cols = [r[1] for r in cur.execute(f'PRAGMA table_info("{t}")')]
        n = cur.execute(f'SELECT count(*) FROM "{t}"').fetchone()[0]
        print(f'{t}  ({n} rows)\n    {", ".join(cols)}')
    con.close()


if __name__ == "__main__":
    if "--schema" in sys.argv:
        i = sys.argv.index("--schema")
        pat = sys.argv[i + 1] if i + 1 < len(sys.argv) else None
        if not os.path.exists(DB):
            build()
        schema(pat)
    else:
        build()
