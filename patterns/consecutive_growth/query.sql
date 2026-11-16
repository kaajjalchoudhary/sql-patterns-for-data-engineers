-- Find streaks of month-over-month growth and how long each lasted.
-- Flag every month that did not grow; a running sum of those flags gives each streak an id.
WITH flagged AS (
    SELECT month, revenue,
        CASE WHEN revenue > lag(revenue) OVER (ORDER BY month) THEN 0 ELSE 1 END AS breaks_streak
    FROM monthly_revenue
),
grouped AS (
    SELECT *, sum(breaks_streak) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS streak_id
    FROM flagged
)
SELECT
    min(month) AS streak_start,
    max(month) AS streak_end,
    count(*) - 1 AS months_of_growth,
    max(revenue) - min(revenue) AS revenue_gain
FROM grouped
GROUP BY streak_id
HAVING count(*) > 1
ORDER BY streak_start
