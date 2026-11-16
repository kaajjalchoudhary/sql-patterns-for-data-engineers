-- Turn a start/stop event log into run intervals.
-- Each start is paired with the next event on the same machine, but only if that event is a stop.
-- A start followed by another start (a lost stop) or by nothing (still running) gets no end.
WITH sequenced AS (
    SELECT machine, event, event_ts,
        lead(event)    OVER (PARTITION BY machine ORDER BY event_ts) AS next_event,
        lead(event_ts) OVER (PARTITION BY machine ORDER BY event_ts) AS next_ts
    FROM machine_events
)
SELECT
    machine,
    event_ts AS run_start,
    CASE WHEN next_event = 'stop' THEN next_ts END AS run_end,
    CASE
        WHEN next_event = 'stop' THEN 'complete'
        WHEN next_event = 'start' THEN 'missing stop'
        ELSE 'open'
    END AS status
FROM sequenced
WHERE event = 'start'
ORDER BY machine, run_start
