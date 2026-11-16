-- Expand compact ranges (first..last) into one row per value, e.g. to join serials to redemptions.
-- A recursive CTE works on any engine; DuckDB and Postgres can also use generate_series / range.
WITH RECURSIVE serials AS (
    SELECT batch_id, first_serial AS serial, last_serial
    FROM voucher_batches
    UNION ALL
    SELECT batch_id, serial + 1, last_serial
    FROM serials
    WHERE serial < last_serial
)
SELECT batch_id, serial
FROM serials
ORDER BY batch_id, serial
