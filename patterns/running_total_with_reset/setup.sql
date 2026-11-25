CREATE TABLE loyalty_events (
    customer_id VARCHAR, event_date DATE, event_type VARCHAR, points INTEGER
);
INSERT INTO loyalty_events VALUES
    ('A', '2025-01-01', 'earn', 50),   ('A', '2025-01-03', 'earn', 30),
    ('A', '2025-01-04', 'redeem', 80), ('A', '2025-01-06', 'earn', 20),
    ('A', '2025-01-08', 'earn', 10),
    ('B', '2025-01-02', 'earn', 40),   ('B', '2025-01-05', 'earn', 25),
    ('B', '2025-01-07', 'earn', 15);
