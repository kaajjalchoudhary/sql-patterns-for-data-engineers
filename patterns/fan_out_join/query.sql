-- Report order value, amount paid and shipments per customer without double counting.
-- Joining orders to payments AND shipments directly multiplies rows: order 1 has 2 payments and
-- 3 shipments, so a naive join turns it into 6 rows and sum(order_total) counts it 6 times.
-- Aggregate each child table to the order grain first, then join one row per order.
WITH paid AS (
    SELECT order_id, sum(amount) AS paid_amount
    FROM payments
    GROUP BY order_id
),
shipped AS (
    SELECT order_id, count(*) AS shipment_count
    FROM shipments
    GROUP BY order_id
)
SELECT
    o.customer,
    count(*) AS orders,
    sum(o.order_total) AS order_total,
    coalesce(sum(p.paid_amount), 0) AS paid_amount,
    coalesce(sum(s.shipment_count), 0) AS shipments
FROM orders AS o
LEFT JOIN paid AS p ON p.order_id = o.order_id
LEFT JOIN shipped AS s ON s.order_id = o.order_id
GROUP BY o.customer
ORDER BY o.customer
