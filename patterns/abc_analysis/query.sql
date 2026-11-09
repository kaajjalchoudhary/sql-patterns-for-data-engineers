-- ABC (Pareto) analysis: rank products by revenue and classify them by cumulative share.
-- A = the products that make up the first 80% of revenue, B = the next 15%, C = the long tail.
-- The product name breaks ties so equal revenues always land in the same order.
WITH ranked AS (
    SELECT
        product,
        revenue,
        sum(revenue) OVER (ORDER BY revenue DESC, product ROWS UNBOUNDED PRECEDING)
            / sum(revenue) OVER () AS cumulative_share
    FROM sales
)
SELECT
    product,
    revenue,
    round(cumulative_share, 2) AS cumulative_share,
    CASE
        WHEN cumulative_share <= 0.80 THEN 'A'
        WHEN cumulative_share <= 0.95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM ranked
ORDER BY revenue DESC, product
