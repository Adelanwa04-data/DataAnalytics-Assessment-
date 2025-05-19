--  Create a CTE (Common Table Expression) to get monthly transaction counts per user
WITH monthly_txns AS (
    SELECT
        uc.id,  -- User ID
        DATE_FORMAT(uc.created_on, '%Y-%m') AS txn_month,  -- Group by year and month
        COUNT(*) AS monthly_txn_count  -- Count number of transactions (or records) per month
    FROM users_customuser uc
    GROUP BY uc.id, DATE_FORMAT(uc.created_on, '%Y-%m')
),

--  Compute the average number of transactions per month for each customer
avg_txns_per_customer AS (
    SELECT
        owner_id,  -- Customer/user ID
        ROUND(AVG(transaction_type_id), 1) AS avg_txns_per_month  -- Average transactions per month (assumes each row is a transaction)
    FROM savings_savingsaccount
    GROUP BY owner_id
),

--  Categorize each customer based on their average monthly transaction volume
categorized_customers AS (
    SELECT
        owner_id,
        ROUND(AVG(transaction_type_id), 1) AS avg_txns_per_month,
        CASE
            WHEN ROUND(AVG(transaction_type_id), 2) >= 10 THEN 'High Frequency'  
            WHEN ROUND(AVG(transaction_type_id), 2) BETWEEN 3 AND 9.99 THEN 'Medium Frequency'  
            ELSE 'Low Frequency'  
        END AS frequency_category
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- Summarize customer counts and average transaction activity per frequency category
SELECT
    frequency_category,  -- 'High Frequency', 'Medium Frequency', or 'Low Frequency'
    COUNT(*) AS customer_count,  -- Number of customers in this category
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month  -- Average of the average transactions
FROM categorized_customers
GROUP BY frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Sort in logical order
