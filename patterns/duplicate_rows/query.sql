-- Two different problems that both look like "duplicates":
--   exact copy  - every column identical (a re-delivered file), safe to drop the extras
--   key clash   - same event_id but different content, needs investigation, never silently drop
WITH per_key AS (
    SELECT
        event_id,
        count(*) AS row_count,
        count(DISTINCT CAST(user_id AS VARCHAR) || '|' || event_type || '|' || event_ts) AS distinct_versions
    FROM raw_events
    GROUP BY event_id
)
SELECT
    event_id,
    row_count,
    distinct_versions,
    CASE WHEN distinct_versions = 1 THEN 'exact copy' ELSE 'key clash' END AS issue
FROM per_key
WHERE row_count > 1
ORDER BY event_id
