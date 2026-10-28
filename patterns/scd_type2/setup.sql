CREATE TABLE customer_snapshots (snapshot_date DATE, customer_id INTEGER, tier VARCHAR);
INSERT INTO customer_snapshots VALUES
    ('2025-01-01', 1, 'bronze'), ('2025-01-02', 1, 'bronze'), ('2025-01-03', 1, 'silver'),
    ('2025-01-04', 1, 'silver'), ('2025-01-05', 1, 'gold'),
    ('2025-01-01', 2, 'silver'), ('2025-01-03', 2, 'silver'), ('2025-01-05', 2, 'silver');
