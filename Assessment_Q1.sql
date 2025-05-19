USE adashi_staging;

# Task 1: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

SELECT 
    savings.owner_id,
    savings.name,
    savings.savings_count,
    investments.investment_count,
    ROUND((savings.total_savings + investments.total_investment)/100, 2) AS total_deposits # addition of both amounts to 2dp in Naira
FROM (
    SELECT 
        s.owner_id,
        CONCAT(u.first_name, " ", u.last_name) AS name,
        COUNT(DISTINCT s.plan_id) AS savings_count, # counting the distinct plans
        SUM(s.confirmed_amount) AS total_savings # sum of inflow into the plans
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    JOIN users_customuser u ON s.owner_id = u.id
    WHERE p.is_regular_savings = 1 # to filter the distinct plans for savings alone
		AND s.confirmed_amount > 0 # to filter for only funded plans
    GROUP BY s.owner_id
) AS savings # to serve as the first table in the from statement
JOIN (
    SELECT 
        s.owner_id,
        COUNT(DISTINCT s.plan_id) AS investment_count, # count all distinct plans
        SUM(s.confirmed_amount) AS total_investment # sum of inflow
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 1 # to filter the plans for investment only
		AND s.confirmed_amount > 0 # to filter for only funded plans
    GROUP BY s.owner_id
) AS investments
ON savings.owner_id = investments.owner_id # to join the 2 subqueries in the from statement
ORDER BY total_deposits;

-- 179 Rows returned