-- Turn two full snapshots into a change feed. IS DISTINCT FROM treats NULLs as values,
-- so customer 7 (NULL -> 'silver') is caught while customer 4 (NULL -> NULL) is not.
SELECT
    coalesce(t.customer_id, y.customer_id) AS customer_id,
    CASE
        WHEN y.customer_id IS NULL THEN 'insert'
        WHEN t.customer_id IS NULL THEN 'delete'
        ELSE 'update'
    END AS change_type,
    CASE
        WHEN y.customer_id IS NOT NULL AND t.customer_id IS NOT NULL THEN concat_ws(
            ',',
            CASE WHEN y.email IS DISTINCT FROM t.email THEN 'email' END,
            CASE WHEN y.tier IS DISTINCT FROM t.tier THEN 'tier' END
        )
    END AS changed_columns
FROM yesterday AS y
FULL OUTER JOIN today AS t ON y.customer_id = t.customer_id
WHERE y.customer_id IS NULL
   OR t.customer_id IS NULL
   OR y.email IS DISTINCT FROM t.email
   OR y.tier IS DISTINCT FROM t.tier
ORDER BY coalesce(t.customer_id, y.customer_id)
