## 4 For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest

WITH transactions_volume AS( # cte to calculate transaction volume across tenure months
SELECT u.id,
	CONCAT(u.first_name, " ", u.last_name) AS name, # concatenate first and last names
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months, # the number of months between current date and date joined
    ROUND(SUM(s.confirmed_amount/100), 2) AS total_transactions # amount of transaction in naira rounded to 2 decimal places
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.confirmed_amount > 0 # to filter for only funded accounts
GROUP BY u.id # aggregation of results based on user_id
)
SELECT id,
	name,
    tenure_months,
    total_transactions,
    ROUND(((total_transactions/tenure_months) * 12 * 0.1), 2) AS estimated_clv # estimated clv rounded to 2 decimal place
FROM transactions_volume
ORDER BY estimated_clv DESC;

-- 872 rows returned