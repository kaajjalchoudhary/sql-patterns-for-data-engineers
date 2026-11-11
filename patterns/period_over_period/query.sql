-- Month-over-month change in revenue, as an absolute amount and a percentage.
-- nullif guards the division: growth from a zero month is undefined, so it stays NULL
-- instead of failing the query or reporting an infinite percentage.
SELECT
    month_start,
    revenue,
    lag(revenue) OVER w AS prev_revenue,
    revenue - lag(revenue) OVER w AS change,
    round(100.0 * (revenue - lag(revenue) OVER w) / nullif(lag(revenue) OVER w, 0), 1) AS pct_change
FROM monthly_revenue
WINDOW w AS (ORDER BY month_start)
ORDER BY month_start
