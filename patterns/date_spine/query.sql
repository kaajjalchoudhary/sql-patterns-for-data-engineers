-- Daily revenue with one row for every calendar day, including days with no orders.
-- Without the spine, quiet days vanish and charts and running totals silently skip them.
WITH bounds AS (
    SELECT min(order_date) AS first_day, max(order_date) AS last_day
    FROM orders
),
spine AS (
    SELECT CAST(day_ts AS DATE) AS day
    FROM (
        SELECT unnest(generate_series(
            CAST(first_day AS TIMESTAMP), CAST(last_day AS TIMESTAMP), INTERVAL 1 DAY
        )) AS day_ts
        FROM bounds
    ) AS days
),
daily AS (
    SELECT order_date, count(*) AS orders, sum(amount) AS revenue
    FROM orders
    GROUP BY order_date
)
SELECT
    spine.day,
    coalesce(daily.orders, 0) AS orders,
    coalesce(daily.revenue, 0) AS revenue,
    sum(coalesce(daily.revenue, 0)) OVER (ORDER BY spine.day) AS cumulative_revenue
FROM spine
LEFT JOIN daily ON daily.order_date = spine.day
ORDER BY spine.day
