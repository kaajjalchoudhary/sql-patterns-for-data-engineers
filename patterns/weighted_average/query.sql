-- Average of pre-aggregated rows must be weighted by their counts.
-- avg(stars) treats a 2-review bucket like a 120-review bucket; sum(x * w) / sum(w) does not.
-- Multiply by 1.0 so integer division cannot truncate on engines that do it.
SELECT
    product,
    sum(num_reviews) AS total_reviews,
    round(avg(stars), 2) AS naive_avg,
    round(1.0 * sum(stars * num_reviews) / sum(num_reviews), 2) AS weighted_avg
FROM product_ratings
GROUP BY product
ORDER BY product
