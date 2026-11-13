-- Collapse repeated heartbeats of the same state into one row per state change, with how long it lasted.
-- Keep a row only when the status differs from the previous one for that order (IS DISTINCT FROM
-- also handles the first row, where lag() is NULL). Unlike GROUP BY status, a state that comes back
-- later (paid -> shipped -> paid) stays a separate period.
WITH flagged AS (
    SELECT
        order_id, status, event_ts,
        lag(status) OVER (PARTITION BY order_id ORDER BY event_ts) AS prev_status
    FROM order_status_events
),
changes AS (
    SELECT order_id, status, event_ts AS valid_from
    FROM flagged
    WHERE status IS DISTINCT FROM prev_status
)
SELECT
    order_id,
    status,
    valid_from,
    lead(valid_from) OVER (PARTITION BY order_id ORDER BY valid_from) AS valid_to
FROM changes
ORDER BY order_id, valid_from
