-- Share of the region and share of the grand total in one pass, no self-join needed.
-- 100.0 forces decimal division; with integers some engines would return 0.
SELECT
    region,
    product,
    revenue,
    round(100.0 * revenue / sum(revenue) OVER (PARTITION BY region), 1) AS pct_of_region,
    round(100.0 * revenue / sum(revenue) OVER (), 1) AS pct_of_total
FROM sales
ORDER BY region, revenue DESC
