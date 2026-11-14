CREATE TABLE orders (order_id INTEGER, customer VARCHAR, order_total DECIMAL(10, 2));
CREATE TABLE payments (payment_id INTEGER, order_id INTEGER, amount DECIMAL(10, 2));
CREATE TABLE shipments (shipment_id INTEGER, order_id INTEGER);
INSERT INTO orders VALUES
    (1, 'acme',   100.00),
    (2, 'acme',    50.00),
    (3, 'globex', 200.00),
    (4, 'globex',  80.00);
INSERT INTO payments VALUES
    (10, 1, 60.00),
    (11, 1, 40.00),
    (12, 2, 50.00),
    (13, 3, 200.00);
INSERT INTO shipments VALUES
    (20, 1),
    (21, 1),
    (22, 1),
    (23, 3);
