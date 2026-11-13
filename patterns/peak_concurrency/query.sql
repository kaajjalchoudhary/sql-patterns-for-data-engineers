-- Find the peak number of sessions open at the same time on each server, and when it first happened.
-- Turn every session into two events (+1 at start, -1 at end) and keep a running sum.
-- Sort ends before starts at the same timestamp (delta -1 before +1), so a session ending at 09:30
-- and one starting at 09:30 do not overlap: intervals are half-open [start, end).
WITH events AS (
    SELECT server, start_ts AS ts, 1 AS delta FROM sessions
    UNION ALL
    SELECT server, end_ts AS ts, -1 AS delta FROM sessions
),
running AS (
    SELECT
        server, ts,
        sum(delta) OVER (
            PARTITION BY server ORDER BY ts, delta ROWS UNBOUNDED PRECEDING
        ) AS concurrent
    FROM events
),
ranked AS (
    SELECT
        server, ts, concurrent,
        row_number() OVER (PARTITION BY server ORDER BY concurrent DESC, ts) AS rn
    FROM running
)
SELECT
    server,
    concurrent AS peak_sessions,
    ts AS first_peak_at
FROM ranked
WHERE rn = 1
ORDER BY server
