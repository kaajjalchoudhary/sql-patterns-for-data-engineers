-- Median and p90 delivery time per city. Averages hide the slow tail that SLAs care about.
-- quantile_cont interpolates between the two nearest values; use quantile_disc when the answer
-- must be a value that actually occurs in the data.
SELECT
    city,
    count(*) AS deliveries,
    median(minutes) AS median_minutes,
    quantile_cont(minutes, 0.9) AS p90_minutes
FROM deliveries
GROUP BY city
ORDER BY city
