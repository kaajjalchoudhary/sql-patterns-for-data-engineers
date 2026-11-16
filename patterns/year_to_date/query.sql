-- Year-to-date and grand running totals side by side.
-- Partitioning the running sum by year makes it restart every January.
SELECT
    month,
    revenue,
    sum(revenue) OVER (
        PARTITION BY substr(month, 1, 4) ORDER BY month ROWS UNBOUNDED PRECEDING
    ) AS ytd_revenue,
    sum(revenue) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS running_revenue
FROM monthly_sales
ORDER BY month
