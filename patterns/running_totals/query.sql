-- Cumulative totals and moving averages with explicit window frames.
SELECT
    day,
    revenue,
    sum(revenue) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING) AS running_total,
    round(avg(revenue) OVER (ORDER BY day ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
        AS moving_avg_3d
FROM daily_revenue
ORDER BY day
