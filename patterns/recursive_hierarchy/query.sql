-- Walk an org chart (or any parent/child table) from the root down.
-- The anchor picks the root rows, the recursive step joins children to the rows found so far.
-- Carrying a path string gives a stable depth-first sort order and makes cycles easy to spot.
WITH RECURSIVE tree AS (
    SELECT employee_id, name, manager_id, 0 AS depth, name AS path
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.name, e.manager_id, t.depth + 1, t.path || ' > ' || e.name
    FROM employees AS e
    JOIN tree AS t ON e.manager_id = t.employee_id
)
SELECT employee_id, name, depth, path
FROM tree
ORDER BY path
