CREATE TABLE events (user_id INTEGER, event_name VARCHAR, event_time TIMESTAMP);
INSERT INTO events VALUES
    -- full funnel
    (1, 'view', '2025-01-01 10:00:00'), (1, 'cart', '2025-01-01 10:05:00'), (1, 'purchase', '2025-01-01 10:10:00'),
    -- drops off after cart
    (2, 'view', '2025-01-01 11:00:00'), (2, 'cart', '2025-01-01 11:02:00'),
    -- only views
    (3, 'view', '2025-01-01 12:00:00'),
    -- never viewed, so not in the funnel at all
    (4, 'cart', '2025-01-01 09:00:00'), (4, 'purchase', '2025-01-01 09:30:00'),
    -- purchase happened BEFORE the view and cart, so it does not count
    (5, 'purchase', '2025-01-01 08:00:00'), (5, 'view', '2025-01-01 08:10:00'), (5, 'cart', '2025-01-01 08:20:00'),
    -- repeated views are fine
    (6, 'view', '2025-01-01 13:00:00'), (6, 'view', '2025-01-01 13:05:00'),
    (6, 'cart', '2025-01-01 13:10:00'), (6, 'purchase', '2025-01-01 13:20:00');
