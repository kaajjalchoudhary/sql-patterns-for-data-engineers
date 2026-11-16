-- Drawdown: how far each value sits below the highest value seen so far.
-- A running max() is the "peak"; the gap to it is the drawdown, often shown as a percentage.
SELECT
    day,
    balance,
    max(balance) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING) AS running_peak,
    balance - max(balance) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING) AS drawdown,
    round(100.0 * (balance - max(balance) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING))
          / max(balance) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING), 1) AS drawdown_pct
FROM daily_balance
ORDER BY day
