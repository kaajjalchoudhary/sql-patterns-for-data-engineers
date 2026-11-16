-- Split each month's active customers into new (first purchase that month) and returning.
-- Find every customer's first month once, then compare it with each active month.
WITH first_month AS (
    SELECT customer_id, min(month) AS first_month
    FROM purchases
    GROUP BY customer_id
),
active AS (
    SELECT DISTINCT customer_id, month FROM purchases
)
SELECT
    a.month,
    count(*) AS active_customers,
    sum(CASE WHEN a.month = f.first_month THEN 1 ELSE 0 END) AS new_customers,
    sum(CASE WHEN a.month > f.first_month THEN 1 ELSE 0 END) AS returning_customers
FROM active AS a
JOIN first_month AS f ON f.customer_id = a.customer_id
GROUP BY a.month
ORDER BY a.month
