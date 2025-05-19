USE adashi_staging;

# Task 2:Calculate the average number of transactions per customer per month and categorize them:
# monthly transactions for each user per month before aggregation
WITH monthly_transc AS # create a cte that shows the monthly amount of monthly transactions of each user
(
SELECT u.id,
	DATE_FORMAT(s.transaction_date, '%Y-%M') as trans_mnth, # to extract the year and month to allow for proper counting
    COUNT(s.savings_id) as num_trans # number of transactions
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
GROUP BY u.id, trans_mnth # to get the number of transactions of each user for each of the months
ORDER BY trans_mnth
),
avg_transaction AS # another cte for average monthly user transaction with frequency labels
(
SELECT id,
	AVG(num_trans) as avg_mnthly_trans,
CASE # to create a frequency category with the avg(num)trans)
	WHEN AVG(num_trans) > 9 THEN "High Frequency"
    WHEN AVG(num_trans) >2 THEN "Medium Frequency"
    ELSE "Low Frequency"
END AS frequency_category
FROM monthly_transc
GROUP BY id
) #aggregate the number of users in each frequency label and average the frequencies
SELECT frequency_category,
	COUNT(frequency_category) as customer_count,
    ROUND(AVG(avg_mnthly_trans), 2) as ave_trans_per_month
FROM avg_transaction
GROUP BY frequency_category
ORDER BY ave_trans_per_month;

-- 3 rows returned