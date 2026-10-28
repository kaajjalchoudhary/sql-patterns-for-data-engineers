-- Find streaks of consecutive days (login streaks, uptime runs, consecutive failures).
-- Trick: date minus its row number is constant within a run of consecutive dates.
WITH days AS (
    SELECT DISTINCT user_id, login_date FROM logins
),
grouped AS (
    SELECT
        user_id,
        login_date,
        login_date - CAST(row_number() OVER (PARTITION BY user_id ORDER BY login_date) AS INTEGER)
            AS island
    FROM days
)
SELECT user_id, min(login_date) AS streak_start, max(login_date) AS streak_end, count(*) AS days
FROM grouped
GROUP BY user_id, island
ORDER BY user_id, streak_start
