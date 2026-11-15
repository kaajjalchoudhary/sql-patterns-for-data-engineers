-- Turn one column per quarter into one row per (region, quarter): the long shape that charts,
-- joins and GROUP BY want. Cross join each row with the list of column names and pick the
-- matching value with CASE. This works on any engine; DuckDB, Snowflake and others also have UNPIVOT.
-- Drop NULLs so a quarter with no data is a missing row, not a zero.
WITH periods(period) AS (
    VALUES ('q1'), ('q2'), ('q3'), ('q4')
),
unpivoted AS (
    SELECT
        r.region,
        p.period,
        CASE p.period
            WHEN 'q1' THEN r.q1
            WHEN 'q2' THEN r.q2
            WHEN 'q3' THEN r.q3
            WHEN 'q4' THEN r.q4
        END AS revenue
    FROM quarterly_revenue AS r
    CROSS JOIN periods AS p
)
SELECT region, period, revenue
FROM unpivoted
WHERE revenue IS NOT NULL
ORDER BY region, period
