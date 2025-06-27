-- 4. Display member borrowing trends using LAG function to show previous transaction date

SELECT 
    member_id,
    transaction_id,
    issue_date,
    LAG(issue_date) OVER (
        PARTITION BY member_id 
        ORDER BY issue_date
    ) AS previous_transaction_date
FROM TRANSACTIONS
ORDER BY member_id, issue_date;
