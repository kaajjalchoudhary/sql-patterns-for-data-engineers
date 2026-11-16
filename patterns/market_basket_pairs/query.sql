-- Which products are bought together? Self-join order lines on the order id.
-- a.product < b.product keeps each pair once (no (butter, bread) duplicate, no (bread, bread)).
SELECT
    a.product AS product_a,
    b.product AS product_b,
    count(DISTINCT a.order_id) AS orders_together
FROM order_lines AS a
JOIN order_lines AS b
    ON a.order_id = b.order_id
   AND a.product < b.product
GROUP BY a.product, b.product
HAVING count(DISTINCT a.order_id) >= 2
ORDER BY orders_together DESC, product_a, product_b
