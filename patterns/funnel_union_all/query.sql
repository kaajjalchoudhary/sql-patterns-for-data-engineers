-- Funnel built with UNION ALL: one SELECT per step, stacked into a single long table.
-- Each step only keeps users who reached the previous step, so counts can never grow down the funnel.
-- A second UNION ALL adds an 'All devices' total on top of the per-device breakdown.
-- (For a funnel where steps must also happen in time order, see funnel_conversion.)
WITH step_1 AS (
    SELECT DISTINCT user_id FROM events WHERE event_name = 'visit'
),
step_2 AS (
    SELECT DISTINCT e.user_id
    FROM events AS e
    JOIN step_1 AS s ON s.user_id = e.user_id
    WHERE e.event_name = 'signup'
),
step_3 AS (
    SELECT DISTINCT e.user_id
    FROM events AS e
    JOIN step_2 AS s ON s.user_id = e.user_id
    WHERE e.event_name = 'purchase'
),
funnel AS (
    SELECT 1 AS step, 'visit'    AS step_name, user_id FROM step_1
    UNION ALL
    SELECT 2 AS step, 'signup'   AS step_name, user_id FROM step_2
    UNION ALL
    SELECT 3 AS step, 'purchase' AS step_name, user_id FROM step_3
),
counts AS (
    SELECT u.device, f.step, f.step_name, count(*) AS users
    FROM funnel AS f
    JOIN users AS u ON u.user_id = f.user_id
    GROUP BY u.device, f.step, f.step_name
    UNION ALL
    SELECT 'All devices' AS device, step, step_name, count(*) AS users
    FROM funnel
    GROUP BY step, step_name
)
SELECT
    device,
    step,
    step_name,
    users,
    round(1.0 * users / first_value(users) OVER (PARTITION BY device ORDER BY step), 3) AS conversion_from_start,
    round(1.0 * users / lag(users) OVER (PARTITION BY device ORDER BY step), 3) AS conversion_from_previous
FROM counts
ORDER BY CASE WHEN device = 'All devices' THEN 0 ELSE 1 END, device, step
