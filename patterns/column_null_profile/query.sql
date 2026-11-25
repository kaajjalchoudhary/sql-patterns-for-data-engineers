-- Completeness profile: nulls, null percentage and distinct values per column.
-- count(*) counts rows, count(col) skips nulls, so the difference is the null count.
-- Run it on a new source before trusting it, or as a data quality gate in a pipeline.
SELECT *
FROM (
    SELECT
        'email' AS column_name,
        count(*) AS total_rows,
        count(*) - count(email) AS null_count,
        round(100.0 * (count(*) - count(email)) / count(*), 1) AS null_pct,
        count(DISTINCT email) AS distinct_values
    FROM customers
    UNION ALL
    SELECT
        'phone',
        count(*),
        count(*) - count(phone),
        round(100.0 * (count(*) - count(phone)) / count(*), 1),
        count(DISTINCT phone)
    FROM customers
    UNION ALL
    SELECT
        'country',
        count(*),
        count(*) - count(country),
        round(100.0 * (count(*) - count(country)) / count(*), 1),
        count(DISTINCT country)
    FROM customers
) AS profile
ORDER BY column_name
