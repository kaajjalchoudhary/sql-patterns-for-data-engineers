-- Most frequent value per group (the statistical mode), e.g. each customer's usual payment method.
-- Count first, then rank the counts. The second ORDER BY key breaks ties deterministically
-- (customer 200 used cash and wallet twice each; cash wins alphabetically).
WITH counts AS (
    SELECT customer_id, payment_method, count(*) AS times_used
    FROM orders
    GROUP BY customer_id, payment_method
),
ranked AS (
    SELECT *,
        row_number() OVER (PARTITION BY customer_id ORDER BY times_used DESC, payment_method) AS rn
    FROM counts
)
SELECT customer_id, payment_method AS usual_payment_method, times_used
FROM ranked
WHERE rn = 1
ORDER BY customer_id
