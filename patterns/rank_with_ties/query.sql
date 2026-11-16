-- The three ranking functions differ only in how they treat ties:
--   row_number() - always unique (ties broken by the extra ORDER BY key)
--   rank()       - ties share a rank, then the next rank skips (1, 2, 2, 4)
--   dense_rank() - ties share a rank, no gaps (1, 2, 2, 3)
-- "Top 3 scores" means dense_rank() <= 3; "top 3 students" means row_number() <= 3.
SELECT
    student,
    score,
    row_number() OVER (ORDER BY score DESC, student) AS row_num,
    rank()       OVER (ORDER BY score DESC) AS rnk,
    dense_rank() OVER (ORDER BY score DESC) AS dense_rnk
FROM exam_scores
ORDER BY row_num
