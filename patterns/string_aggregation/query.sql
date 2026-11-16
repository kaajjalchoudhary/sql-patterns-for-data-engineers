-- Collapse many rows into one delimited string per key (exports, emails, quick reviews).
-- ORDER BY inside the aggregate makes the output stable; DISTINCT removes repeated tags first.
SELECT
    ticket_id,
    count(DISTINCT tag) AS tag_count,
    string_agg(tag, ', ' ORDER BY tag) AS tags
FROM (SELECT DISTINCT ticket_id, tag FROM ticket_tags) AS t
GROUP BY ticket_id
ORDER BY ticket_id
