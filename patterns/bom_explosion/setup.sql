CREATE TABLE bom (parent VARCHAR, component VARCHAR, qty INTEGER);
-- one bike needs 2 wheels; each wheel needs 32 spokes and 1 rim; one frame needs 4 bolts
INSERT INTO bom VALUES
    ('bike',  'frame', 1),
    ('bike',  'wheel', 2),
    ('wheel', 'spoke', 32),
    ('wheel', 'rim',   1),
    ('frame', 'bolt',  4);
