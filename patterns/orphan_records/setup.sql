CREATE TABLE customers (customer_id INTEGER, name VARCHAR);
INSERT INTO customers VALUES (1, 'Aisha'), (2, 'Ravi'), (3, 'Leo');
CREATE TABLE orders (order_id INTEGER, customer_id INTEGER, amount DECIMAL(10, 2));
INSERT INTO orders VALUES
    (101, 1, 50.00), (102, 4, 20.00), (103, NULL, 15.00),
    (104, 2, 30.00), (105, 4, 12.50);
