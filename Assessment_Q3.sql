SELECT
    p.id AS plan_id,          -- Select the unique ID of the plan
    sa.owner_id,              -- Select the ID of the customer who owns the savings account
    CASE
        -- Categorize the plan based on keywords in its description
        WHEN LOWER(p.description) LIKE '%mutual fund%' OR
             LOWER(p.description) LIKE '%managed portfolio%' OR
             LOWER(p.description) LIKE '%fixed investment%' OR
             LOWER(p.description) LIKE '%usd index%' THEN 'Investment'
        ELSE 'Savings'
    END AS category,
    
    DATE(MAX(sa.created_on)) AS last_transaction_date,           -- Get the date of the last transaction on the account
    DATEDIFF(CURDATE(), MAX(sa.created_on)) AS inactivity_days   -- Calculate how many days have passed since the last transaction
FROM plans_plan p
-- Join with savings accounts to associate plans with user activity
JOIN savings_savingsaccount sa ON sa.plan_id = p.id
-- Join with user table to access customer details (not directly used in SELECT, may be for filtering or future expansion)
JOIN users_customuser uc ON uc.id = sa.owner_id
-- Filter for only inactive plans
WHERE is_active = 0
-- Group by plan, owner, and derived category so that aggregations work correctly
GROUP BY p.id, sa.owner_id, category
-- Only include plans that have been inactive for more than one year
HAVING MAX(sa.created_on) < CURDATE() - INTERVAL 365 DAY
-- Order the results by most inactive plans first
ORDER BY inactivity_days DESC;
