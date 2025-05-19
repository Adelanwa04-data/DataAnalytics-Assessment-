--  Get all users with regular savings plans, count them and sum the amount
WITH funded_savings AS (
    SELECT 
        owner_id, 
        COUNT(is_regular_savings) AS savings_count,          -- Number of regular savings plans
        SUM(amount) AS total_savings                         -- Total amount saved
    FROM plans_plan
    WHERE is_regular_savings = 1                             -- Filter only regular savings plans
    GROUP BY owner_id
),

--  Get all users with investment plans (funds), count them and sum the amount
funded_investments AS (
    SELECT 
        owner_id, 
        COUNT(is_a_fund) AS investment_count,                -- Number of investment plans
        SUM(amount) AS total_investment                      -- Total amount invested
    FROM plans_plan
    WHERE is_a_fund = 1                                      -- Filter only fund-based investment plans
    GROUP BY owner_id
),

--  Combine savings and investment data for users who have both
combined AS (
    SELECT 
        fs.owner_id,
        fs.savings_count,
        fs.total_savings,
        fi.investment_count,
        fi.total_investment,
        (fs.total_savings + fi.total_investment) AS total_deposits -- Combined value of savings and investments
    FROM funded_savings fs
    JOIN funded_investments fi ON fs.owner_id = fi.owner_id   -- Only include users with both savings and investments
)

--  Join with user table to get user details and order by total deposits
SELECT 
    combined.owner_id AS owner_id,
    CONCAT(first_name, ' ', last_name) AS name,               -- User's full name
    combined.total_savings,
    combined.total_investment,
    combined.total_deposits
FROM combined
JOIN users_customuser uc ON uc.id = combined.owner_id         -- Fetch user's personal details
ORDER BY combined.total_deposits DESC;                        -- Rank users by total deposit