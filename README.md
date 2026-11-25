# SQL Patterns for Data Engineers

[![CI](https://github.com/kaajjalchoudhary/sql-patterns-for-data-engineers/actions/workflows/ci.yml/badge.svg)](https://github.com/kaajjalchoudhary/sql-patterns-for-data-engineers/actions/workflows/ci.yml)

Forty-nine SQL patterns that come up again and again in data pipelines and interviews. Each one has
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
| [Funnel with UNION ALL](patterns/funnel_union_all/query.sql) | Step-by-step funnel with a per-device breakdown and an overall total | one `SELECT` per step stacked with `UNION ALL` |
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
| [Unpivot](patterns/unpivot/query.sql) | Wide spreadsheet-style columns to long rows | `CROSS JOIN` column list + `CASE` |
| [Overlapping ranges](patterns/overlapping_ranges/query.sql) | Validity periods that conflict, e.g. two prices on one day | self-join where each starts before the other ends |
| [Recursive hierarchy](patterns/recursive_hierarchy/query.sql) | Org charts, category trees, bill of materials | `WITH RECURSIVE` + path string |
| [Mode per group](patterns/mode_per_group/query.sql) | Each customer's usual payment method or store | `count(*)` then `row_number()` |
| [Market basket pairs](patterns/market_basket_pairs/query.sql) | Products bought together, cross-sell rules | self-join with `a.product < b.product` |
| [Source vs target reconciliation](patterns/source_target_reconciliation/query.sql) | Proving a load is complete: counts and totals per day | aggregate both sides + `FULL OUTER JOIN` |
| [Consecutive growth streaks](patterns/consecutive_growth/query.sql) | Months of uninterrupted growth, winning streaks | `lag()` break flags + running `sum()` |
| [Weighted average](patterns/weighted_average/query.sql) | Averages over pre-aggregated rows (ratings, rates) | `sum(x * w) / sum(w)` |
| [Duplicate rows vs key clashes](patterns/duplicate_rows/query.sql) | Telling re-delivered rows from conflicting records | `count(*)` vs `count(DISTINCT row)` |
| [Rank with ties](patterns/rank_with_ties/query.sql) | Choosing between top-N rows and top-N values | `row_number()` vs `rank()` vs `dense_rank()` |
| [NTILE segments](patterns/ntile_segments/query.sql) | Spend quartiles, deciles, equal-sized test groups | `ntile(n)` with a tie-breaker |
| [Start/stop pairing](patterns/start_stop_pairing/query.sql) | Machine runs, shifts or jobs from an event log, with lost stops | `lead()` on event type and time |
| [Year-to-date totals](patterns/year_to_date/query.sql) | YTD next to all-time running totals, restarting each January | running `sum()` partitioned by year |
| [Inventory balance](patterns/inventory_balance/query.sql) | Stock on hand after each movement, catching oversold SKUs | running `sum()` + negative-balance flag |
| [Bill of materials explosion](patterns/bom_explosion/query.sql) | Total base parts needed to build one product | `WITH RECURSIVE` multiplying quantities |
| [Nth event per entity](patterns/nth_event/query.sql) | Second purchase, third login, time to repeat buyer | `row_number()` + `LEFT JOIN` on order number |
| [String aggregation](patterns/string_aggregation/query.sql) | One delimited list per key for exports and reviews | `string_agg(... ORDER BY ...)` |
| [Expand ranges to rows](patterns/expand_ranges/query.sql) | Serial-number or ticket ranges to one row per value | recursive CTE (or `generate_series`) |
| [Percent of total](patterns/percent_of_total/query.sql) | Share of group and share of grand total in one pass | `sum() OVER (PARTITION BY ...)` and `OVER ()` |
| [New vs returning customers](patterns/new_vs_returning/query.sql) | Monthly active users split by first-time and repeat | first month per customer + `CASE` counts |
| [Drawdown from peak](patterns/drawdown/query.sql) | Balance or KPI decline from its running high | running `max()` |
| [Top N plus 'Other'](patterns/top_n_with_other/query.sql) | Chart-ready top categories with the long tail folded in | `row_number()` + relabel + `GROUP BY` |
| [Time between events](patterns/time_between_events/query.sql) | Days since the previous order, repeat vs reactivated customers | `lag()` + `date_diff()` |
| [Running total with reset](patterns/running_total_with_reset/query.sql) | Loyalty points, streak counters or budgets that restart after a reset event | running count of resets as a group key + running `sum()` |

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
