-- Running total that resets to zero whenever a reset event (here a redemption) occurs.
-- Step 1: a running count of resets gives every row a reset_group number.
-- Step 2: sum only the earned points within customer + reset_group.
-- The reset row opens its group and adds nothing, so its balance is 0.
WITH grouped AS (
    SELECT
        *,
        sum(CASE WHEN event_type = 'redeem' THEN 1 ELSE 0 END) OVER (
            PARTITION BY customer_id ORDER BY event_date ROWS UNBOUNDED PRECEDING
        ) AS reset_group
    FROM loyalty_events
)
SELECT
    customer_id,
    event_date,
    event_type,
    points,
    sum(CASE WHEN event_type = 'earn' THEN points ELSE 0 END) OVER (
        PARTITION BY customer_id, reset_group ORDER BY event_date ROWS UNBOUNDED PRECEDING
    ) AS balance
FROM grouped
ORDER BY customer_id, event_date
