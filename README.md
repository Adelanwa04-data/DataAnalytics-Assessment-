# DataAnalytics-Assessment-
Data Analyst Assessment
---
### 1. High-Value Customers with Multiple Products
#### Approach
As this problem is designed to identify users with at least one funded savings plan or investment plan thento sort them by their total depodsits (savings + investments), I took the following actions;

- Filtered plans where is_regular_savings = 1 (i.e., savings plans).
- Used aggregate functions 'COUNT' and 'SUM' to provide the number of saving plans and the total amount saved by that user.
- Filtered plans where is_a_fund = 1 (i.e., investment plans).
- Used Aggregate function similarly by owner_id.
- Used inner join to ensure that only users who appear in both CTEs above are included i.e users who have both savings and investment plans.
- Calculated a new field: total_deposits = total_savings + total_investment.
- I joined with with users_customuser table to get the user's name.
- Sorted the results by total_deposits in descending order — i.e., highest total funders appear first.

---
### 2. Transaction Frequency Analysis
#### Approach
This query's goal is to calculate the average number of transactions per customer per month, categorize each customer into "High", "Medium", or "Low Frequency" tiers
and to summarize how many customers fall into each category and their average monthly transaction rate. I took the following action to achieve my goal;

- Created a CTE (Common Table Expression) to get monthly transaction counts per user
- Selected the identifier, groupped by year and month from the date each observation was created, counted number of transaction per month from user_customuser table
- Computed the average number of trnsactions per month for each customer
- Selected an identifier, calculated the average transactions per month from savings_savingsaccount table
- Categorized each customer based on their average monthly transaction volume
- Summarized the customers and their average activity with their respective category
- Sorted the output in a logical order

#### Challenges
Determining which field to use for grouping by year and month required careful consideration, as the field descriptions lacked sufficient detail. I reviewed all available datetime fields in the table and selected the one that was most logically aligned with the context of the analysis.

---
### 3. Account Inactivity Alert
#### Approach
- The question specifies inactive accounts. So we expect a filter for is_active = 0.
- Your query used WHERE is_active = 0, which would mean inactive accounts, so this is likely a bug or a detail to clarify.
- Joined plans_plan (holding plan details) with savings_savingsaccount to link plans with accounts and their transaction records.
- Joined with users_customuser to possibly filter or fetch user-related info (even if not directly used in the SELECT).
- Used a CASE statement on the plan description to classify as "Investment" or "Savings". This helps segment the results meaningfully.
- Used MAX(sa.created_on) to find the most recent transaction date for each account (plan + owner combo).
- Used HAVING MAX(sa.created_on) < CURDATE() - INTERVAL 365 DAY to only include accounts with no transaction in the last year.
- Groupped by plan ID, owner ID, and category ensures each row is an individual plan-account combination.
- Sorted results so the longest inactive accounts come first.

#### Challenges
It was challenging to solve this question due to the absence of necessary fields distinguishing savings and investment accounts. To address this, I researched best practices online and devised a method to classify the 'description' field into either 'Savings' or 'Investment' based on keyword patterns.

---
### 4. Customer Lifetime Value (CLV) Estimation
#### Approach
- Selected the customer’s unique ID and full name from the users table.
- Calculated how long the user has been registered, in full months, from their signup date to the current date.
- Counted how many transaction records the customer has in the savings_savingsaccount table. Assuming each record represents a transaction.
- Calculated the CLV using the formula provided
- Joined customer and transaction tables
- Groupped by customer so aggregate functions like COUNT() and AVG() work correctly
- Ranked customers from highest to lowest estimated CLV


