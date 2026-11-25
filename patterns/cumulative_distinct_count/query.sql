-- Cumulative distinct customers per day.
-- count(DISTINCT ...) cannot be used as a window function, so count each
-- customer once on their first day, then take a running sum of those new customers.
WITH daily AS (
    SELECT order_date, count(DISTINCT customer_id) AS active_customers
    FROM orders
    GROUP BY order_date
),
first_seen AS (
    SELECT customer_id, min(order_date) AS first_date
    FROM orders
    GROUP BY customer_id
),
new_per_day AS (
    SELECT first_date, count(*) AS new_customers
    FROM first_seen
    GROUP BY first_date
)
SELECT
    d.order_date,
    d.active_customers,
    coalesce(n.new_customers, 0) AS new_customers,
    sum(coalesce(n.new_customers, 0)) OVER (
        ORDER BY d.order_date ROWS UNBOUNDED PRECEDING
    ) AS cumulative_customers
FROM daily AS d
LEFT JOIN new_per_day AS n ON n.first_date = d.order_date
ORDER BY d.order_date
