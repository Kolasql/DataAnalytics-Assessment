# DataAnalytics-Assessment
# Assessment Q1
Query to find customers with at least one funded savings AND one funded investment sorted by total deposits.
  - The approach I took was to create two subqueries: one for funded savings and the other for funded investments.
  - Since both savings and investment plans were both inflows represented in the plan_id, what I did was to count the number of distinct plan_id.
  - I filtered on is_regular_savings = 1 for savings and is_a_fund for investments.
  - To ensure that the results are funded plans only confirmed_payment had to be greater than 0.
  - Each subquery acted as a table with a Join statement connecting both with the owner_id.
  - The total savings and total investments were added together in the final select statement, divided by 100 to convert naira, and rounded to 2dp.
  - The Final query returned 179 rows.

## Challenges Encountered
  - The main challenge I had initially was when I attempted to write the query without first isolating the savings from the investments, I was getting the same number for both columns.
  - The next challenge is not adding the filter "confirmed_amount > 0", I was seeing empty rows in my query.

# Assessment Q2
Query to calculate the average monthly transactions for each category of customers.
  - Two CTEs were created. One calculated the number of monthly transactions per user.
  - The second CTE calculated the average transaction per month and segregated these customers by categories.
  - The final select statement extracted the categories, averages, and the number of customers in each category.

# Assessment Q3
Query to find all active accounts(savings or investments) with no transactions in the last 1 year (365).
  - Like the previous challenge, I also created a CTE to pull the most recent transactions.
  - The most recent transactions were pulled together whether savings or investments.
  - The transaction was filtered with "confirmed_amount > 0" to ensure it is the last funded.
  - Account_type was filtered to remove null values to ensure only savings and investments are included in the results.
  - Inactivity days was calculated as the day difference between the current date and last transaction date.
  - the final query is filtered to show only results with days of inactivity greater than 365 days.
  - 1634 rows returned from query.
## Challenges
  - The main challenge was not being sure of the date to use to compare with the last transaction date. I eventually had to settle for the cuurent date function of MYSQL.

# Assessment Q4
Query to estimate Customer Lifetime Value (clv) based on account tenure and transaction volume.
  - I created a CTE to calculate the transaction volume across the tenure months.
  - to calculate the tenure months, I calculated the number of months between cuurent_date and date_joined.
  - The total_transaction was calculated in naira before the clv was calculated.
  - The final query showed the estimated_clv in descending order.
