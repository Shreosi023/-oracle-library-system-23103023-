-- Task 2.1: Data Queries

-- 1. List all books where available copies are less than total copies
SELECT 
    book_id, 
    title, 
    total_copies, 
    available_copies
FROM BOOKS
WHERE available_copies < total_copies;

-- 2. Find members who have overdue books
SELECT 
    M.member_id, 
    M.first_name, 
    M.last_name, 
    T.book_id, 
    T.due_date
FROM MEMBERS M
JOIN TRANSACTIONS T ON M.member_id = T.member_id
WHERE T.due_date < CURDATE() AND T.status = 'Overdue';

-- 3. Display top 5 most borrowed books with borrow count
SELECT 
    B.book_id, 
    B.title, 
    COUNT(T.transaction_id) AS borrow_count
FROM BOOKS B
JOIN TRANSACTIONS T ON B.book_id = T.book_id
GROUP BY B.book_id, B.title
ORDER BY borrow_count DESC
LIMIT 5;

-- 4. Show members who have never returned a book on time
SELECT DISTINCT 
    M.member_id, 
    M.first_name, 
    M.last_name
FROM MEMBERS M
JOIN TRANSACTIONS T ON M.member_id = T.member_id
WHERE T.return_date > T.due_date;


-- Task 2.2: Data Manipulation

-- 1. Update fine amounts for overdue transactions (₹5 per day)
SET SQL_SAFE_UPDATES = 0;
UPDATE TRANSACTIONS
SET fine_amount = DATEDIFF(return_date, due_date) * 5
WHERE return_date > due_date;

-- 2. Insert a new member if email/phone doesn't already exist
INSERT INTO MEMBERS (
    member_id, first_name, last_name, email, phone, address, membership_date, membership_type
)
SELECT 
    16, 'Rafi', 'Hasan', 'rafi@example.com', '01234567906', 'Narsingdi, BD', CURDATE(), 'Student'
WHERE NOT EXISTS (
    SELECT 1 FROM MEMBERS WHERE email = 'rafi@example.com' OR phone = '01234567906'
);

-- 3. Archive completed transactions older than 2 years
-- Step 1: Create archive table
CREATE TABLE IF NOT EXISTS TRANSACTION_ARCHIVE AS
SELECT * FROM TRANSACTIONS WHERE 1 = 0;

-- Step 2: Move data to archive
INSERT INTO TRANSACTION_ARCHIVE
SELECT * FROM TRANSACTIONS
WHERE status = 'Returned' AND return_date < CURDATE() - INTERVAL 2 YEAR;

DELETE FROM TRANSACTIONS
WHERE status = 'Returned' AND return_date < CURDATE() - INTERVAL 2 YEAR;

-- 4. Update book categories based on publication year
UPDATE BOOKS
SET category = CASE
    WHEN YEAR(publication_year) < 2000 THEN 'Classic'
    WHEN YEAR(publication_year) BETWEEN 2000 AND 2010 THEN 'Standard'
    ELSE 'Modern'
END;


-- Task 3.1: Joins

-- 1. Transaction history with member and book info (overdue only)
SELECT 
    T.transaction_id,
    M.member_id, M.first_name, M.last_name,
    B.book_id, B.title, B.category,
    T.issue_date, T.due_date, T.return_date, T.status
FROM TRANSACTIONS T
INNER JOIN MEMBERS M ON T.member_id = M.member_id
INNER JOIN BOOKS B ON T.book_id = B.book_id
WHERE T.status = 'Overdue';

-- 2. Show all books and their transaction count (including never borrowed)
SELECT 
    B.book_id, 
    B.title, 
    COUNT(T.transaction_id) AS transaction_count
FROM BOOKS B
LEFT JOIN TRANSACTIONS T ON B.book_id = T.book_id
GROUP BY B.book_id, B.title
ORDER BY transaction_count DESC;

-- 3. Find members who borrowed books from the same category as other members
SELECT DISTINCT 
    M1.member_id AS member1_id, M1.first_name AS member1_name,
    M2.member_id AS member2_id, M2.first_name AS member2_name,
    B1.category
FROM TRANSACTIONS T1
JOIN MEMBERS M1 ON T1.member_id = M1.member_id
JOIN BOOKS B1 ON T1.book_id = B1.book_id
JOIN TRANSACTIONS T2 ON B1.category = (
    SELECT B2.category FROM BOOKS B2 WHERE B2.book_id = T2.book_id
)
JOIN MEMBERS M2 ON T2.member_id = M2.member_id
WHERE M1.member_id <> M2.member_id;

-- 4. Generate member-book recommendation pairs (limit 50)
SELECT 
    M.member_id, M.first_name, M.last_name,
    B.book_id, B.title, B.category
FROM MEMBERS M
CROSS JOIN BOOKS B
LIMIT 50;


-- Task 3.2: Subqueries and Aggregates

-- 1. Books borrowed more times than the average borrowing rate
SELECT book_id, title
FROM BOOKS
WHERE book_id IN (
    SELECT book_id
    FROM TRANSACTIONS
    GROUP BY book_id
    HAVING COUNT(*) > (
        SELECT AVG(borrow_count)
        FROM (
            SELECT COUNT(*) AS borrow_count
            FROM TRANSACTIONS
            GROUP BY book_id
        ) AS borrow_stats
    )
);

-- 2. Members whose total fine exceeds their membership type's average fine
SELECT 
    member_id, first_name, last_name, total_fine
FROM (
    SELECT 
        M.member_id, M.first_name, M.last_name, M.membership_type,
        SUM(T.fine_amount) AS total_fine
    FROM MEMBERS M
    JOIN TRANSACTIONS T ON M.member_id = T.member_id
    GROUP BY M.member_id, M.first_name, M.last_name, M.membership_type
) AS member_fines
WHERE total_fine > (
    SELECT AVG(total_fine)
    FROM (
        SELECT 
            M.member_id, M.membership_type, SUM(T.fine_amount) AS total_fine
        FROM MEMBERS M
        JOIN TRANSACTIONS T ON M.member_id = T.member_id
        GROUP BY M.member_id, M.membership_type
    ) AS type_fines
    WHERE type_fines.membership_type = member_fines.membership_type
);

-- 3. Available books in the most borrowed category
SELECT book_id, title, category
FROM BOOKS
WHERE available_copies > 0
AND category = (
    SELECT B.category
    FROM BOOKS B
    JOIN TRANSACTIONS T ON B.book_id = T.book_id
    GROUP BY B.category
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 4. Find second most active member by transaction count
SELECT 
    member_id, first_name, last_name, txn_count
FROM (
    SELECT 
        M.member_id, M.first_name, M.last_name, COUNT(T.transaction_id) AS txn_count
    FROM MEMBERS M
    JOIN TRANSACTIONS T ON M.member_id = T.member_id
    GROUP BY M.member_id, M.first_name, M.last_name
) AS member_txns
WHERE txn_count = (
    SELECT MAX(txn_count) FROM (
        SELECT COUNT(transaction_id) AS txn_count
        FROM TRANSACTIONS
        GROUP BY member_id
        HAVING COUNT(transaction_id) < (
            SELECT MAX(txn_count_inner) FROM (
                SELECT COUNT(transaction_id) AS txn_count_inner
                FROM TRANSACTIONS
                GROUP BY member_id
            ) AS all_txns_inner
        )
    ) AS second_max
);


-- Task 3.3: Aggregates & Window Functions

-- 1. Running total of fines collected by month
SELECT 
    DATE_FORMAT(return_date, '%Y-%m') AS month,
    SUM(fine_amount) AS monthly_fine,
    SUM(SUM(fine_amount)) OVER (ORDER BY DATE_FORMAT(return_date, '%Y-%m')) AS running_total
FROM TRANSACTIONS
WHERE fine_amount > 0
GROUP BY month
ORDER BY month;

-- 2. Rank members by borrowing activity within each membership type
SELECT 
    member_id, first_name, last_name, membership_type, borrow_count,
    RANK() OVER (PARTITION BY membership_type ORDER BY borrow_count DESC) AS rank_within_type
FROM (
    SELECT 
        M.member_id, M.first_name, M.last_name, M.membership_type, 
        COUNT(T.transaction_id) AS borrow_count
    FROM MEMBERS M
    LEFT JOIN TRANSACTIONS T ON M.member_id = T.member_id
    GROUP BY M.member_id, M.first_name, M.last_name, M.membership_type
) AS sub;

-- 3. Percentage contribution of each book category to total transactions
SELECT 
    B.category,
    COUNT(T.transaction_id) AS category_transaction_count,
    ROUND(100 * COUNT(T.transaction_id) / (SELECT COUNT(*) FROM TRANSACTIONS), 2) AS percentage_contribution
FROM BOOKS B
LEFT JOIN TRANSACTIONS T ON B.book_id = T.book_id
GROUP BY B.category
ORDER BY percentage_contribution DESC;
