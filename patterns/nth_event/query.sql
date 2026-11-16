-- Each customer's second order (the moment a buyer becomes a repeat buyer).
-- Customers with only one order are kept with NULLs, so conversion rates stay honest.
WITH numbered AS (
    SELECT *, row_number() OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS order_number
    FROM orders
)
SELECT
    c.customer_id,
    o1.order_date AS first_order_date,
    o2.order_date AS second_order_date,
    o2.amount AS second_order_amount
FROM (SELECT DISTINCT customer_id FROM orders) AS c
JOIN numbered AS o1 ON o1.customer_id = c.customer_id AND o1.order_number = 1
LEFT JOIN numbered AS o2 ON o2.customer_id = c.customer_id AND o2.order_number = 2
ORDER BY c.customer_id
