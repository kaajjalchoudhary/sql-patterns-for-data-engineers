# SQL Patterns for Data Engineers

[![CI](https://github.com/kaajjalchoudhary/sql-patterns-for-data-engineers/actions/workflows/ci.yml/badge.svg)](https://github.com/kaajjalchoudhary/sql-patterns-for-data-engineers/actions/workflows/ci.yml)

Seven SQL patterns that come up again and again in data pipelines and interviews. Each one has
sample data, a commented query and the expected result, and CI runs every query on DuckDB to
prove it works.

| Pattern | Use it for | Key technique |
|---|---|---|
| [Dedupe to latest](patterns/dedupe_latest/query.sql) | CDC feeds, re-delivered files | `QUALIFY row_number()` |
| [Gaps and islands](patterns/gaps_and_islands/query.sql) | Login streaks, uptime runs | date minus row number |
| [Sessionization](patterns/sessionization/query.sql) | Clickstream sessions | `lag()` + running `sum()` |
| [Running totals](patterns/running_totals/query.sql) | Cumulative revenue, moving averages | window frames |
| [Top N per group](patterns/top_n_per_group/query.sql) | Best sellers per category | `row_number()` with a tie-breaker |
| [SCD Type 2](patterns/scd_type2/query.sql) | Dimension history from snapshots | `IS DISTINCT FROM` + `lead()` |
| [Date spine](patterns/date_spine/query.sql) | Daily charts with no missing days, cumulative metrics | `generate_series` + `LEFT JOIN` |

## Run them

```bash
pip install -r requirements.txt
python run.py --list
python run.py sessionization
pytest            # checks every pattern against expected.csv
```

## Add a pattern

Create `patterns/<name>/` with `setup.sql` (tables and sample rows), `query.sql` and
`expected.csv`. The test suite picks it up automatically.

## License

MIT
