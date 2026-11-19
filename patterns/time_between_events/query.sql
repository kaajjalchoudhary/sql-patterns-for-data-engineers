-- Time between events: how long since the same entity's previous event.
-- lag() over a per-customer window gives the previous order; date_diff() turns it into days.
-- A long gap marks a lapsed customer coming back, which is often reported separately from repeat orders.
SELECT
    customer_id,
    order_date,
    lag(order_date) OVER w AS prev_order_date,
    date_diff('day', lag(order_date) OVER w, order_date) AS days_since_prev,
    CASE
        WHEN lag(order_date) OVER w IS NULL THEN 'first'
        WHEN date_diff('day', lag(order_date) OVER w, order_date) > 60 THEN 'reactivated'
        ELSE 'repeat'
    END AS order_type
FROM orders
WINDOW w AS (PARTITION BY customer_id ORDER BY order_date)
ORDER BY customer_id, order_date
