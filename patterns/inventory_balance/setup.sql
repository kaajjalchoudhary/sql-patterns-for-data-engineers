CREATE TABLE stock_movements (sku VARCHAR, moved_at VARCHAR, qty INTEGER);
-- positive qty = goods received, negative = goods shipped
INSERT INTO stock_movements VALUES
    ('A-100', '2025-06-01 08:00:00',  50),
    ('A-100', '2025-06-02 10:00:00', -20),
    ('A-100', '2025-06-03 09:00:00', -40),
    ('A-100', '2025-06-04 07:30:00',  30),
    ('B-200', '2025-06-01 12:00:00',  10),
    ('B-200', '2025-06-05 15:00:00',  -4);
