-- Bill of materials: how many of each base part does one bike need?
-- The recursive step multiplies quantities down the tree; parts that are never a parent are leaves.
WITH RECURSIVE exploded AS (
    SELECT component, qty AS total_qty, 1 AS level
    FROM bom
    WHERE parent = 'bike'
    UNION ALL
    SELECT b.component, e.total_qty * b.qty, e.level + 1
    FROM bom AS b
    JOIN exploded AS e ON b.parent = e.component
)
SELECT component AS part, sum(total_qty) AS qty_per_bike
FROM exploded
WHERE component NOT IN (SELECT parent FROM bom)
GROUP BY component
ORDER BY component
