CREATE TABLE machine_events (machine VARCHAR, event VARCHAR, event_ts VARCHAR);
INSERT INTO machine_events VALUES
    ('press-1', 'start', '2025-05-01 08:00:00'),
    ('press-1', 'stop',  '2025-05-01 09:30:00'),
    ('press-1', 'start', '2025-05-01 10:00:00'),
    ('press-1', 'stop',  '2025-05-01 12:00:00'),
    ('press-2', 'start', '2025-05-01 08:15:00'),
    ('press-2', 'start', '2025-05-01 08:20:00'),
    ('press-2', 'stop',  '2025-05-01 11:00:00'),
    ('press-2', 'start', '2025-05-01 13:00:00');
