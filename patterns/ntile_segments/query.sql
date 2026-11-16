-- Split customers into equal-sized spend quartiles (1 = top 25%).
-- ntile(n) hands out buckets by row position, so equal values can land in different buckets;
-- add a tie-breaker so the result is deterministic.
SELECT
    customer_id,
    total_spend,
    ntile(4) OVER (ORDER BY total_spend DESC, customer_id) AS spend_quartile
FROM customer_spend
ORDER BY spend_quartile, total_spend DESC
