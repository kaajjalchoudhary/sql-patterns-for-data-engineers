-- Group users by the month they were first active, then count how many are active
-- 0, 1, 2... months later. Several visits in one month count once.
WITH firsts AS (
    SELECT user_id, CAST(date_trunc('month', min(activity_date)) AS DATE) AS cohort_month
    FROM activity
    GROUP BY user_id
),
active AS (
    SELECT DISTINCT
        a.user_id,
        f.cohort_month,
        date_diff('month', f.cohort_month, CAST(date_trunc('month', a.activity_date) AS DATE)) AS month_number
    FROM activity AS a
    JOIN firsts AS f ON a.user_id = f.user_id
),
sizes AS (
    SELECT cohort_month, count(*) AS cohort_size
    FROM firsts
    GROUP BY cohort_month
)
SELECT
    a.cohort_month,
    a.month_number,
    count(*) AS active_users,
    s.cohort_size,
    round(count(*) / s.cohort_size, 3) AS retention
FROM active AS a
JOIN sizes AS s ON a.cohort_month = s.cohort_month
GROUP BY a.cohort_month, a.month_number, s.cohort_size
ORDER BY a.cohort_month, a.month_number
