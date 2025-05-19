SELECT
    uc.id AS customer_id,  -- Unique identifier for each customer

    CONCAT(uc.first_name, ' ', uc.last_name) AS name,  -- Full name of the customer

    -- Account tenure in months (from account creation to current date)
    TIMESTAMPDIFF(MONTH, uc.created_on, CURDATE()) AS tenure_months,

    -- Total number of transactions made by the customer
    COUNT(sa.id) AS total_transactions,

    -- Estimated Customer Lifetime Value (CLV)
    ROUND(
        (COUNT(sa.id) / NULLIF(TIMESTAMPDIFF(MONTH, uc.created_on, CURDATE()), 0))  -- Avoid division by zero
        * 12 
        * (AVG(sa.amount) * 0.001),
        2  -- Round to 2 decimal places
    ) AS estimated_clv

FROM users_customuser uc
JOIN savings_savingsaccount sa ON sa.owner_id = uc.id  -- Join savings accounts with users
GROUP BY uc.id, name  -- Group by unique user and full name
ORDER BY estimated_clv DESC;  -- Rank users by highest estimated CLV
