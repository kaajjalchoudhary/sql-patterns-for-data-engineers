-- Credit each conversion to the first and the last marketing touch that happened before it.
-- Only touches at or before converted_at count: the 'display' touch after user 1 converted is ignored.
-- Rank touches both ways with row_number() and a tie-breaker on channel, so two touches at the
-- same timestamp still give one deterministic answer. Conversions with no touch keep NULLs (LEFT JOIN).
WITH eligible AS (
    SELECT
        c.user_id,
        t.channel,
        row_number() OVER (PARTITION BY c.user_id ORDER BY t.touch_ts, t.channel) AS rn_first,
        row_number() OVER (PARTITION BY c.user_id ORDER BY t.touch_ts DESC, t.channel DESC) AS rn_last
    FROM conversions AS c
    JOIN touches AS t
        ON t.user_id = c.user_id
       AND t.touch_ts <= c.converted_at
)
SELECT
    c.user_id,
    c.revenue,
    f.channel AS first_touch,
    l.channel AS last_touch
FROM conversions AS c
LEFT JOIN eligible AS f ON f.user_id = c.user_id AND f.rn_first = 1
LEFT JOIN eligible AS l ON l.user_id = c.user_id AND l.rn_last = 1
ORDER BY c.user_id
