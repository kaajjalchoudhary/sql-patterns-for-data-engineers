-- Collapse overlapping or touching time ranges into one busy block per room.
-- A row starts a new block when it begins after every earlier row in the room has ended,
-- so compare against the running max(end_ts), not just the previous row (that misses nested ranges).
WITH ordered AS (
    SELECT
        room, start_ts, end_ts,
        max(end_ts) OVER (
            PARTITION BY room ORDER BY start_ts, end_ts
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS prev_max_end
    FROM bookings
),
flagged AS (
    SELECT *,
        CASE WHEN prev_max_end IS NULL OR start_ts > prev_max_end THEN 1 ELSE 0 END AS is_new_block
    FROM ordered
),
grouped AS (
    SELECT *,
        sum(is_new_block) OVER (
            PARTITION BY room ORDER BY start_ts, end_ts ROWS UNBOUNDED PRECEDING
        ) AS block_id
    FROM flagged
)
SELECT
    room,
    min(start_ts) AS block_start,
    max(end_ts) AS block_end,
    count(*) AS bookings_merged
FROM grouped
GROUP BY room, block_id
ORDER BY room, block_start
