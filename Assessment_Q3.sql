# 3 Account Inactivity
# Find all active accounts(savings or investments) with no transactions in the last 1 year (365)
-- get the most recent cashflows whether it is savings or investments

With recent_transactions AS ( # cte to pull out the most recent transactions
SELECT s.plan_id,
	s.owner_id,
    MAX(s.transaction_date) AS most_recent_transaction, # Max is used to select the most recent
    CASE
		WHEN p.is_regular_savings = 1 THEN "Savings" # labelled as savings when it is savings
        WHEN p.is_a_fund = 1 THEN "Investments" # labelled as investment when it is investments
	END AS account_type
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
WHERE s.confirmed_amount > 0 # filter to ensure it is funded
GROUP BY s.plan_id, s.owner_id
ORDER BY s.plan_id
)
SELECT plan_id,
	owner_id,
    account_type AS type,
    DATE(most_recent_transaction) AS last_transaction_date, # Date is to ignore the timestamp
    DATEDIFF(CURDATE(), DATE(most_recent_transaction)) AS inactivity_days # to calculate the number of days between current date and the last transaction date
FROM recent_transactions
WHERE account_type IS NOT NULL # filter to ensure that only savings and investments are included
HAVING inactivity_days > 365
ORDER BY inactivity_days DESC;
