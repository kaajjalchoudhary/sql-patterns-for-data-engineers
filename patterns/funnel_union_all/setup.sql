CREATE TABLE users (user_id INTEGER, device VARCHAR);
INSERT INTO users VALUES
    (1, 'mobile'), (2, 'mobile'), (3, 'mobile'), (7, 'mobile'),
    (4, 'desktop'), (5, 'desktop'), (6, 'desktop');

CREATE TABLE events (user_id INTEGER, event_name VARCHAR);
INSERT INTO events VALUES
    -- full funnel
    (1, 'visit'), (1, 'signup'), (1, 'purchase'),
    -- repeated visit, stops at signup
    (2, 'visit'), (2, 'visit'), (2, 'signup'),
    -- visit only
    (3, 'visit'), (7, 'visit'),
    -- buys twice, still counted once
    (4, 'visit'), (4, 'signup'), (4, 'purchase'), (4, 'purchase'),
    (5, 'visit'), (5, 'signup'),
    -- no visit: skipped the top of the funnel, so excluded from every step
    (6, 'signup'), (6, 'purchase');
