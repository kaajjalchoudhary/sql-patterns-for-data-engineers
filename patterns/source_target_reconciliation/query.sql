-- Reconcile a load: compare row counts and totals per day between source and target.
-- Aggregate each side first, then FULL OUTER JOIN so days missing on either side still show up.
WITH src AS (
    SELECT load_date, count(*) AS rows_src, sum(amount) AS amount_src
    FROM source_orders GROUP BY load_date
),
tgt AS (
    SELECT load_date, count(*) AS rows_tgt, sum(amount) AS amount_tgt
    FROM target_orders GROUP BY load_date
)
SELECT
    coalesce(src.load_date, tgt.load_date) AS load_date,
    coalesce(rows_src, 0) AS rows_src,
    coalesce(rows_tgt, 0) AS rows_tgt,
    coalesce(amount_src, 0) - coalesce(amount_tgt, 0) AS amount_diff,
    CASE
        WHEN src.load_date IS NULL THEN 'only in target'
        WHEN tgt.load_date IS NULL THEN 'missing in target'
        WHEN rows_src = rows_tgt AND amount_src = amount_tgt THEN 'ok'
        ELSE 'mismatch'
    END AS status
FROM src
FULL OUTER JOIN tgt ON src.load_date = tgt.load_date
ORDER BY 1
