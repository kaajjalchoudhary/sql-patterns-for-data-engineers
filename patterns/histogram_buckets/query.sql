-- Histogram of order amounts in fixed-width buckets of 50, including empty buckets.
-- floor(amount / width) gives the bucket number; a generated list of bucket numbers
-- keeps the empty ones so the distribution chart has no silent gaps.
WITH binned AS (
    SELECT CAST(floor(amount / 50) AS INTEGER) AS bucket
    FROM orders
),
buckets AS (
    SELECT unnest(range(0, (SELECT max(bucket) FROM binned) + 1)) AS bucket
)
SELECT
    buckets.bucket * 50 AS bucket_from,
    (buckets.bucket + 1) * 50 AS bucket_to,
    count(binned.bucket) AS orders
FROM buckets
LEFT JOIN binned ON binned.bucket = buckets.bucket
GROUP BY buckets.bucket
ORDER BY buckets.bucket
