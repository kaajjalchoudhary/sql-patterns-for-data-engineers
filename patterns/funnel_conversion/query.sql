-- Ordered funnel: a user counts for a step only if it happened after the previous step.
-- Counting each event type independently would wrongly credit user 4 and user 5.
WITH viewed AS (
    SELECT user_id, min(event_time) AS viewed_at
    FROM events
    WHERE event_name = 'view'
    GROUP BY user_id
),
carted AS (
    SELECT v.user_id, v.viewed_at, min(e.event_time) AS carted_at
    FROM viewed AS v
    LEFT JOIN events AS e
        ON e.user_id = v.user_id AND e.event_name = 'cart' AND e.event_time >= v.viewed_at
    GROUP BY v.user_id, v.viewed_at
),
purchased AS (
    SELECT c.user_id, c.carted_at, min(e.event_time) AS purchased_at
    FROM carted AS c
    LEFT JOIN events AS e
        ON e.user_id = c.user_id AND e.event_name = 'purchase' AND e.event_time >= c.carted_at
    GROUP BY c.user_id, c.carted_at
),
steps AS (
    SELECT 1 AS step, 'view' AS step_name, count(*) AS users FROM purchased
    UNION ALL
    SELECT 2, 'cart', count(carted_at) FROM purchased
    UNION ALL
    SELECT 3, 'purchase', count(purchased_at) FROM purchased
)
SELECT
    step,
    step_name,
    users,
    round(users / first_value(users) OVER (ORDER BY step), 3) AS conversion_from_start,
    round(users / lag(users) OVER (ORDER BY step), 3) AS conversion_from_previous
FROM steps
ORDER BY step
