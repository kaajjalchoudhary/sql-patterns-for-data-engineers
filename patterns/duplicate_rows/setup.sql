CREATE TABLE raw_events (event_id INTEGER, user_id INTEGER, event_type VARCHAR, event_ts VARCHAR);
INSERT INTO raw_events VALUES
    (1, 10, 'click',    '2025-04-01 10:00:00'),
    (1, 10, 'click',    '2025-04-01 10:00:00'),
    (2, 11, 'view',     '2025-04-01 10:05:00'),
    (3, 12, 'purchase', '2025-04-01 10:07:00'),
    (3, 12, 'purchase', '2025-04-01 10:07:00'),
    (3, 12, 'purchase', '2025-04-01 10:07:00'),
    (4, 10, 'click',    '2025-04-01 10:09:00'),
    (4, 13, 'click',    '2025-04-01 10:09:00');
