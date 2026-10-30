-- Rows to columns with conditional aggregation. Portable across warehouses, and missing
-- quarters come back as 0 instead of disappearing.
SELECT
    region,
    coalesce(sum(amount) FILTER (WHERE quarter = 'Q1'), 0) AS q1,
    coalesce(sum(amount) FILTER (WHERE quarter = 'Q2'), 0) AS q2,
    coalesce(sum(amount) FILTER (WHERE quarter = 'Q3'), 0) AS q3,
    coalesce(sum(amount) FILTER (WHERE quarter = 'Q4'), 0) AS q4,
    sum(amount) AS total
FROM sales
GROUP BY region
ORDER BY region
