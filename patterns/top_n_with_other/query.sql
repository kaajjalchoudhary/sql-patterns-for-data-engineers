-- Keep the top 3 sources and fold the long tail into a single 'Other' row, as charts usually need.
-- Rank once, relabel everything below the cut-off, then aggregate; totals still add up.
WITH ranked AS (
    SELECT source, visits, row_number() OVER (ORDER BY visits DESC, source) AS rn
    FROM traffic
),
labelled AS (
    SELECT CASE WHEN rn <= 3 THEN source ELSE 'Other' END AS source_group,
           CASE WHEN rn <= 3 THEN rn ELSE 4 END AS sort_key,
           visits
    FROM ranked
)
SELECT source_group, sum(visits) AS visits
FROM labelled
GROUP BY source_group, sort_key
ORDER BY sort_key
