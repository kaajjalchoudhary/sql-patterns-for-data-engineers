"""Run a SQL pattern against its sample data in an in-memory DuckDB.

    python run.py --list
    python run.py sessionization
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import duckdb

PATTERNS = Path(__file__).resolve().parent / "patterns"


def list_patterns() -> list[str]:
    return sorted(p.name for p in PATTERNS.iterdir() if (p / "query.sql").exists())


def split_statements(sql: str) -> list[str]:
    """Split a script on semicolons that are not inside single-quoted strings."""
    statements, current, in_string = [], [], False
    for ch in sql:
        if ch == "'":
            in_string = not in_string
        if ch == ";" and not in_string:
            statements.append("".join(current))
            current = []
        else:
            current.append(ch)
    statements.append("".join(current))
    return [s.strip() for s in statements if s.strip()]


def run(name: str) -> tuple[list[str], list[tuple]]:
    folder = PATTERNS / name
    with duckdb.connect() as con:
        for statement in split_statements((folder / "setup.sql").read_text()):
            con.execute(statement)
        result = con.execute((folder / "query.sql").read_text())
        columns = [d[0] for d in result.description]
        return columns, result.fetchall()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("pattern", nargs="?", help="pattern folder name")
    parser.add_argument("--list", action="store_true", help="list available patterns")
    args = parser.parse_args()

    if args.list or not args.pattern:
        print("\n".join(list_patterns()))
        return 0
    if args.pattern not in list_patterns():
        print(f"Unknown pattern {args.pattern!r}. Try --list.", file=sys.stderr)
        return 2

    columns, rows = run(args.pattern)
    cells = [columns] + [["" if v is None else str(v) for v in row] for row in rows]
    widths = [max(len(r[i]) for r in cells) for i in range(len(columns))]
    for i, row in enumerate(cells):
        print("  ".join(v.ljust(w) for v, w in zip(row, widths)).rstrip())
        if i == 0:
            print("  ".join("-" * w for w in widths))
    return 0


if __name__ == "__main__":
    sys.exit(main())
