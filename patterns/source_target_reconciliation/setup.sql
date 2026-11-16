CREATE TABLE source_orders (load_date VARCHAR, order_id INTEGER, amount INTEGER);
CREATE TABLE target_orders (load_date VARCHAR, order_id INTEGER, amount INTEGER);
INSERT INTO source_orders VALUES
    ('2025-03-01', 1, 100), ('2025-03-01', 2, 50),
    ('2025-03-02', 3, 70),  ('2025-03-02', 4, 30),
    ('2025-03-03', 5, 90);
INSERT INTO target_orders VALUES
    ('2025-03-01', 1, 100), ('2025-03-01', 2, 50),
    ('2025-03-02', 3, 70),
    ('2025-03-04', 6, 10);
