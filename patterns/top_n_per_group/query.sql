-- Top 2 products per category. The second ORDER BY key makes ties deterministic
-- (Phone and Tablet both have 900; Phone wins alphabetically).
SELECT category, product, revenue, rank_in_category
FROM (
    SELECT
        *,
        row_number() OVER (PARTITION BY category ORDER BY revenue DESC, product) AS rank_in_category
    FROM sales
)
WHERE rank_in_category <= 2
ORDER BY category, rank_in_category
