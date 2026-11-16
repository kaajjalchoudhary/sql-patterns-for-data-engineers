CREATE TABLE orders (order_id INTEGER, customer_id INTEGER, payment_method VARCHAR);
INSERT INTO orders VALUES
    (1, 100, 'card'), (2, 100, 'card'), (3, 100, 'wallet'),
    (4, 200, 'cash'), (5, 200, 'wallet'), (6, 200, 'wallet'), (7, 200, 'cash'),
    (8, 300, 'card');
