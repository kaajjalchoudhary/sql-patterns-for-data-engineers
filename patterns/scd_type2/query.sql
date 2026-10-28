-- Build a Slowly Changing Dimension Type 2 from daily snapshots: one row per version,
-- with valid_from / valid_to (exclusive) and an is_current flag.
WITH changes AS (
    SELECT
        *,
        tier IS DISTINCT FROM lag(tier) OVER (PARTITION BY customer_id ORDER BY snapshot_date)
            AS is_change
    FROM customer_snapshots
),
versions AS (
    SELECT customer_id, tier, snapshot_date AS valid_from
    FROM changes
    WHERE is_change
)
SELECT
    customer_id,
    tier,
    valid_from,
    lead(valid_from) OVER (PARTITION BY customer_id ORDER BY valid_from) AS valid_to,
    lead(valid_from) OVER (PARTITION BY customer_id ORDER BY valid_from) IS NULL AS is_current
FROM versions
ORDER BY customer_id, valid_from
