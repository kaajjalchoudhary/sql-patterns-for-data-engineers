-- Stock on hand after every movement, and a flag when it goes negative.
-- A negative balance means a shipment was booked before its receipt: a data or process problem
-- that a plain SUM per SKU would hide (A-100 ends positive but was oversold on 06-03).
SELECT
    sku,
    moved_at,
    qty,
    sum(qty) OVER (PARTITION BY sku ORDER BY moved_at ROWS UNBOUNDED PRECEDING) AS on_hand,
    CASE
        WHEN sum(qty) OVER (PARTITION BY sku ORDER BY moved_at ROWS UNBOUNDED PRECEDING) < 0
        THEN 'NEGATIVE' ELSE 'ok'
    END AS check_status
FROM stock_movements
ORDER BY sku, moved_at
