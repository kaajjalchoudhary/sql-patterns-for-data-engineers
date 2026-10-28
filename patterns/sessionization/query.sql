-- Group clickstream events into sessions: a gap of more than 30 minutes starts a new session.
WITH flagged AS (
    SELECT
        user_id,
        event_time,
        CASE
            WHEN event_time - lag(event_time) OVER (PARTITION BY user_id ORDER BY event_time)
                <= INTERVAL 30 MINUTE THEN 0
            ELSE 1
        END AS is_new_session
    FROM events
),
numbered AS (
    SELECT
        *,
        sum(is_new_session) OVER (
            PARTITION BY user_id ORDER BY event_time ROWS UNBOUNDED PRECEDING
        ) AS session_number
    FROM flagged
)
SELECT
    user_id,
    session_number,
    min(event_time) AS session_start,
    max(event_time) AS session_end,
    count(*) AS events,
    date_diff('minute', min(event_time), max(event_time)) AS duration_min
FROM numbered
GROUP BY user_id, session_number
ORDER BY user_id, session_number
