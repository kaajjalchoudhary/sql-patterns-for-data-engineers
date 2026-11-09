-- Price each trade with the latest quote at or before the trade time (a point-in-time lookup).
-- An equi-join on timestamps almost never matches; ASOF picks the closest earlier row per ticker.
-- ASOF LEFT JOIN keeps trades that happened before the first quote, with a NULL price.
SELECT
    t.trade_id,
    t.ticker,
    t.trade_ts,
    p.price_ts,
    p.price,
    t.qty * p.price AS notional
FROM trades AS t
ASOF LEFT JOIN prices AS p
    ON t.ticker = p.ticker AND t.trade_ts >= p.price_ts
ORDER BY t.trade_id
