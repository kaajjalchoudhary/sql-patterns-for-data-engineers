-- Find fact rows whose foreign key has no matching dimension row (a referential integrity check).
-- Use NOT EXISTS, not NOT IN: if the subquery ever returns a NULL, NOT IN matches nothing at all.
-- Rows with a NULL key are orphans too, so they are reported with their own reason.
SELECT
    o.order_id,
    o.customer_id,
    CASE WHEN o.customer_id IS NULL THEN 'missing key' ELSE 'unknown customer' END AS problem
FROM orders AS o
WHERE NOT EXISTS (
    SELECT 1 FROM customers AS c WHERE c.customer_id = o.customer_id
)
ORDER BY o.order_id
