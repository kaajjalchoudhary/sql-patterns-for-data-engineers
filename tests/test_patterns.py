import csv
import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from run import PATTERNS, list_patterns, run, split_statements  # noqa: E402


def _same(actual, expected: str) -> bool:
    """Compare a DuckDB value with a CSV cell, tolerant of number and boolean formatting."""
    if actual is None:
        return expected == ""
    if isinstance(actual, bool):
        return str(actual).lower() == expected.lower()
    try:
        return abs(float(actual) - float(expected)) < 1e-9
    except (TypeError, ValueError):
        return str(actual) == expected


def test_every_pattern_has_all_files():
    for name in list_patterns():
        for f in ("setup.sql", "query.sql", "expected.csv"):
            assert (PATTERNS / name / f).exists(), f"{name} is missing {f}"


@pytest.mark.parametrize("name", list_patterns())
def test_pattern_matches_expected(name):
    columns, rows = run(name)
    with open(PATTERNS / name / "expected.csv", newline="") as fh:
        expected = list(csv.reader(fh))
    assert columns == expected[0]
    assert len(rows) == len(expected) - 1, f"{name}: got {rows}"
    for got, want in zip(rows, expected[1:]):
        assert all(_same(a, e) for a, e in zip(got, want)), f"{name}: got {got}, want {want}"


def test_split_statements_ignores_semicolons_in_strings():
    assert split_statements("SELECT 'a;b'; SELECT 2;") == ["SELECT 'a;b'", "SELECT 2"]
