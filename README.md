# SQL Patterns for Data Engineers

[![CI](https://github.com/kaajjalchoudhary/sql-patterns-for-data-engineers/actions/workflows/ci.yml/badge.svg)](https://github.com/kaajjalchoudhary/sql-patterns-for-data-engineers/actions/workflows/ci.yml)

Twenty-four SQL patterns that come up again and again in data pipelines and interviews. Each one has
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
| [Funnel conversion](patterns/funnel_conversion/query.sql) | Signup and checkout funnels where step order matters | chained `LEFT JOIN` on time + `lag()` |
| [Snapshot diff (CDC)](patterns/snapshot_diff/query.sql) | Inserts, updates and deletes between two full extracts | `FULL OUTER JOIN` + `IS DISTINCT FROM` |
| [Pivot](patterns/pivot/query.sql) | Quarter-by-region reports, wide feature tables | `sum() FILTER (WHERE ...)` |
| [Cohort retention](patterns/cohort_retention/query.sql) | Monthly retention curves by signup cohort | `date_trunc` + `date_diff` |
| [Forward fill](patterns/forward_fill/query.sql) | Sparse sensor or price feeds with missing readings | `last_value(... IGNORE NULLS)` |
| [Merge intervals](patterns/merge_intervals/query.sql) | Room or resource bookings, overlapping outage windows | running `max(end_ts)` + `sum()` |
| [Orphan records](patterns/orphan_records/query.sql) | Referential integrity checks before loading facts | `NOT EXISTS` (not `NOT IN`) |
| [Percentiles](patterns/percentiles/query.sql) | Median and p90 latency or delivery times per group | `median()` + `quantile_cont()` |
| [As-of join](patterns/asof_join/query.sql) | Pricing trades or events with the latest value at that moment | `ASOF LEFT JOIN` |
| [ABC analysis](patterns/abc_analysis/query.sql) | Pareto classes for products, customers or SKUs | cumulative `sum()` / total |
| [Period over period](patterns/period_over_period/query.sql) | Month-over-month or year-over-year growth | `lag()` + `nullif()` |
| [Histogram buckets](patterns/histogram_buckets/query.sql) | Distributions of amounts or durations, with empty buckets kept | `floor(x / width)` + `range()` |
| [Peak concurrency](patterns/peak_concurrency/query.sql) | Max simultaneous sessions, connections or bookings | +1/-1 events + running `sum()` |
| [Missing sequence numbers](patterns/missing_sequence_numbers/query.sql) | Lost messages, skipped batch ids, missing files | `DISTINCT` + `lead()` |
| [Collapse repeated states](patterns/collapse_repeated_states/query.sql) | Status heartbeats to state-change periods | `lag()` + `IS DISTINCT FROM` + `lead()` |
| [Fan-out join](patterns/fan_out_join/query.sql) | Totals across one-to-many joins without double counting | aggregate each child, then `LEFT JOIN` |
| [First and last touch](patterns/first_last_touch/query.sql) | Marketing attribution for conversions | `row_number()` asc and desc + time filter |

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
