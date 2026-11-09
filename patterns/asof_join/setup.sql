CREATE TABLE prices (ticker VARCHAR, price_ts TIMESTAMP, price DOUBLE);
INSERT INTO prices VALUES
    ('AAPL', '2025-06-02 09:30', 190.0), ('AAPL', '2025-06-02 09:35', 191.5),
    ('MSFT', '2025-06-02 09:30', 420.0);
CREATE TABLE trades (trade_id INTEGER, ticker VARCHAR, trade_ts TIMESTAMP, qty INTEGER);
INSERT INTO trades VALUES
    (1, 'AAPL', '2025-06-02 09:29', 10), (2, 'AAPL', '2025-06-02 09:32', 5),
    (3, 'AAPL', '2025-06-02 09:35', 8), (4, 'MSFT', '2025-06-02 09:40', 2);
