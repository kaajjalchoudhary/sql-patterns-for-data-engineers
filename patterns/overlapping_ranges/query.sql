-- Data quality check: find rows whose validity ranges overlap for the same product, so a lookup
-- on a date could return two prices. Ranges are half-open [valid_from, valid_to) and a NULL
-- valid_to means "still valid", so treat it as far in the future.
-- Two ranges overlap when each one starts before the other ends. a.price_id < b.price_id
-- reports each conflicting pair once.
WITH ranges AS (
    SELECT price_id, product, valid_from, coalesce(valid_to, DATE '9999-12-31') AS valid_to
    FROM price_list
)
SELECT
    a.product,
    a.price_id AS price_id_a,
    b.price_id AS price_id_b,
    greatest(a.valid_from, b.valid_from) AS overlap_from,
    least(a.valid_to, b.valid_to) AS overlap_to
FROM ranges AS a
JOIN ranges AS b
    ON a.product = b.product
   AND a.price_id < b.price_id
   AND a.valid_from < b.valid_to
   AND b.valid_from < a.valid_to
ORDER BY a.product, a.price_id, b.price_id
