CREATE TABLE touches (user_id INTEGER, channel VARCHAR, touch_ts TIMESTAMP);
CREATE TABLE conversions (user_id INTEGER, converted_at TIMESTAMP, revenue DECIMAL(10, 2));
INSERT INTO touches VALUES
    (1, 'paid_search', '2025-09-01 09:00'),
    (1, 'email',       '2025-09-03 18:00'),
    (1, 'social',      '2025-09-05 12:00'),
    (1, 'display',     '2025-09-09 10:00'),
    (2, 'organic',     '2025-09-02 08:00'),
    (3, 'referral',    '2025-09-04 14:00'),
    (3, 'email',       '2025-09-04 14:00');
INSERT INTO conversions VALUES
    (1, '2025-09-06 20:00', 120.00),
    (2, '2025-09-02 08:30',  45.00),
    (3, '2025-09-04 15:00',  80.00),
    (4, '2025-09-07 11:00',  30.00);
