CREATE TABLE order_status_events (order_id INTEGER, status VARCHAR, event_ts TIMESTAMP);
INSERT INTO order_status_events VALUES
    (1, 'placed',    '2025-08-01 10:00'),
    (1, 'placed',    '2025-08-01 10:05'),
    (1, 'paid',      '2025-08-01 10:07'),
    (1, 'paid',      '2025-08-01 10:30'),
    (1, 'shipped',   '2025-08-02 09:00'),
    (1, 'paid',      '2025-08-02 09:15'),
    (1, 'shipped',   '2025-08-02 11:00'),
    (2, 'placed',    '2025-08-01 12:00'),
    (2, 'cancelled', '2025-08-01 12:20'),
    (2, 'cancelled', '2025-08-01 12:21');
