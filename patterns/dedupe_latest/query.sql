-- Keep only the latest version of each record (CDC feeds, re-delivered files, upserts).
-- QUALIFY filters on a window function without a subquery.
SELECT customer_id, email, city, updated_at
FROM customer_updates
QUALIFY row_number() OVER (PARTITION BY customer_id ORDER BY updated_at DESC) = 1
ORDER BY customer_id
