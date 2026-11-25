-- Compare every row with its group's average without a self-join.
-- avg() OVER (PARTITION BY ...) keeps the detail rows, unlike GROUP BY.
WITH with_avg AS (
    SELECT
        region,
        store,
        revenue,
        avg(revenue) OVER (PARTITION BY region) AS region_avg
    FROM store_sales
)
SELECT
    region,
    store,
    revenue,
    round(region_avg, 2) AS region_avg,
    round(revenue - region_avg, 2) AS diff_from_avg,
    CASE
        WHEN revenue > region_avg THEN 'above'
        WHEN revenue < region_avg THEN 'below'
        ELSE 'at'
    END AS vs_region
FROM with_avg
ORDER BY region, store
