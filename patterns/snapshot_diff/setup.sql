CREATE TABLE yesterday (customer_id INTEGER, email VARCHAR, tier VARCHAR);
CREATE TABLE today (customer_id INTEGER, email VARCHAR, tier VARCHAR);
INSERT INTO yesterday VALUES
    (1, 'a@example.com', 'gold'),
    (2, 'b@example.com', 'silver'),
    (3, 'c@example.com', 'bronze'),
    (4, 'd@example.com', NULL),
    (6, 'f@example.com', 'gold'),
    (7, 'g@example.com', NULL);
INSERT INTO today VALUES
    (1, 'a@example.com', 'gold'),     -- unchanged
    (2, 'b@example.com', 'gold'),     -- tier upgraded
    (4, 'd@example.com', NULL),       -- unchanged, NULL on both sides
    (5, 'e@example.com', 'silver'),   -- new customer
    (6, 'f@example.org', 'gold'),     -- email changed
    (7, 'g@example.com', 'silver');   -- NULL -> value: missed by <>, caught by IS DISTINCT FROM
