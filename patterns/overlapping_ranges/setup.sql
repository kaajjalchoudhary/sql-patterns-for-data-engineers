CREATE TABLE price_list (price_id INTEGER, product VARCHAR, price DECIMAL(10, 2), valid_from DATE, valid_to DATE);
INSERT INTO price_list VALUES
    (1, 'widget', 10.00, '2025-01-01', '2025-04-01'),
    (2, 'widget', 12.00, '2025-04-01', '2025-07-01'),
    (3, 'widget', 11.50, '2025-06-15', NULL),
    (4, 'gadget', 25.00, '2025-01-01', '2025-03-01'),
    (5, 'gadget', 27.00, '2025-03-01', NULL),
    (6, 'gizmo',   5.00, '2025-01-01', NULL),
    (7, 'gizmo',   5.50, '2025-02-01', '2025-02-15');
