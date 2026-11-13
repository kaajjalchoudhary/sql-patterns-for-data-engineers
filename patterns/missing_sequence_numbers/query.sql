-- Find gaps in a per-source sequence number (lost messages, missing files, skipped batch ids).
-- Deduplicate first: a re-delivered seq_no is not a gap and must not create a fake one.
-- Then compare each seq_no with the next one; anything more than 1 apart is a missing range.
WITH distinct_seq AS (
    SELECT DISTINCT source, seq_no FROM feed_messages
),
with_next AS (
    SELECT
        source,
        seq_no,
        lead(seq_no) OVER (PARTITION BY source ORDER BY seq_no) AS next_seq_no
    FROM distinct_seq
)
SELECT
    source,
    seq_no + 1 AS missing_from,
    next_seq_no - 1 AS missing_to,
    next_seq_no - seq_no - 1 AS missing_count
FROM with_next
WHERE next_seq_no - seq_no > 1
ORDER BY source, missing_from
