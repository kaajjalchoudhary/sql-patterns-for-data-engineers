CREATE TABLE sensor_readings (sensor_id VARCHAR, reading_ts TIMESTAMP, temperature DOUBLE);
INSERT INTO sensor_readings VALUES
    ('s1', '2025-04-01 10:00', 21.5), ('s1', '2025-04-01 10:05', NULL),
    ('s1', '2025-04-01 10:10', NULL), ('s1', '2025-04-01 10:15', 22.0),
    ('s1', '2025-04-01 10:20', NULL),
    ('s2', '2025-04-01 10:00', NULL), ('s2', '2025-04-01 10:05', 18.25),
    ('s2', '2025-04-01 10:10', NULL);
