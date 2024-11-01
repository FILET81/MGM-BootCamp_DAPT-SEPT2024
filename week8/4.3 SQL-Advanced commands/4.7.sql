/*
-- ------------------------------------
		Introduction to subqueries
-- ------------------------------------

Using subqueries is a convenient capability in the language when you 
want one query to operate on the result of another, 
and if you prefer not to use intermediate objects like variables for this purpose. 
Primarily these are the different kinds of subqueries:

	- self-contained - queries that are independent of the outer query.
	- correlated - queries that have references (correlations) to columns of tables from the outer query.
	- scalar - queries that return a single value and that are allowed where a single-valued expression is expected.


Properties/important points on sub queries
	- A subquery is a select statement that is included with another query.
	- Enclose the subquery in parenthesis.
	- A subquery can return a single value, a list of values or a complete table.
	- A subquery can't include an ORDER BY clause.
	- There can be many levels of nesting in the subquery.
	- When you use a subquery, its results can't be included in the SELECT statement of the main query.
*/

/*
Lets use the loan table from the bank database. 
We want to identify the customers who have borrowed amount 
which are more than the average amount of all customers. 
This would not be possible to achieve through simple queries 
that have used before. For this we will use a subquery.
*/
-- step 1: calculate the average
select avg(amount) from bank.loan;

-- step 2 --> pseudo code the main goal of this step ....
select * from bank.loan
where amount > "AVERAGE";

-- step 3 ... create the query
select * from bank.loan
where amount > (
  select avg(amount)
  from bank.loan
);

-- step 4 - Prettify the result. Let's find top 10 such customers
select * from bank.loan
where amount > (select avg(amount)
from bank.loan)
order by amount desc
limit 10;


-- ------------------------------------
-- 		  Subqueries with WHERE
-- ------------------------------------
-- Using comparison operators: 
-- This is a simple example where we are trying to show how subqueries are used. 
-- The same could also be achieved by using HAVING clause and no subquery.

select * from (
  select account_id, bank_to, account_to, sum(amount) as Total
  from bank.order
  group by account_id, bank_to, account_to
) sub1
where total > 10000;

-- Sample A: 
-- In this query we are trying to find those banks from the trans table 
-- where the average amount of transactions is over 5500.
-- If we try to find this result directly, 
-- it would not be possible as we need only the names of the banks and not the averages in this case.
select * from (
  select bank, avg(amount) as Average
  from bank.trans
  where bank <> ''
  group by bank
  having Average > 5500) sub1;
  
select * from (
  select bank, avg(amount) as Average
  from bank.trans
  where bank <> ''
  group by bank
) sub1
WHERE Average > 5500;
  
-- Sample B : 
-- In this query we are trying to find the k_symbols based on the average amount from the table order. 
-- The average amount should be more than 3000.
select k_symbol from (
  select avg(amount) as Average, k_symbol
  from bank.order
  where k_symbol <> ' '
  group by k_symbol
  having Average > 3000
  order by Average desc
) sub1;

/*		ACTIVITY
Find out the average number of transactions by account.
Get those accounts that have more transactions than the average.
*/

select avg(num_trans) from (
  select account_id, count(trans_id) num_trans
  from bank.trans
  group by account_id
) t;

select account_id, count(trans_id) num_trans
from bank.trans 
group by account_id
having count(trans_id) > (
  select avg(num_trans) as avg_num_trans
  from (
    select account_id, count(trans_id) num_trans
    from bank.trans
    group by account_id
  ) t
)
order by num_trans desc;

-- ------------------------------------
-- 					IN
-- ------------------------------------

-- In this query we will use the results from Sample A. 
-- In that query we found the banks from the trans table 
-- where the average amount of transactions is over 5500. 

-- Now we will use those results to filter the results 
-- from the order table where bank_to is 
-- in the list of banks found previously.

select * from bank.order
where bank_to in (
  select bank from (
    select bank, avg(amount) as Average
    from bank.trans
    where bank <> ''
    group by bank
    having Average > 5500
    ) sub1
)
and k_symbol <> ' ';


-- In this query we will use the results from Sample B. 
-- In that query we found the k_symbols based on the average amount 
-- from the table order. The average amount was more than 3000. 

-- Now we will use the results from the query above to only see 
-- the transactions from the trans table where the k_symbol value 
-- is the result from the above query.
select * from bank.trans
where k_symbol in (
  select k_symbol as symbol from (
    select avg(amount) as Average, k_symbol
    from bank.order
    where k_symbol <> ' '
    group by k_symbol
    having Average > 3000
    order by Average desc
  ) sub1
);

/*		ACTIVITY

1. Get a list of accounts from Central Bohemia using a subquery.
2. Rewrite the previous as a join query.
3. Discuss which method will be more efficient.

*/

-- ------------------------------------
-- 			NESTED SUBQUERIES
-- ------------------------------------

-- Here we are again using Sample B to further filter the results based on aggregation 
-- on the balance column as can be seen in the query below:

-- Step 1
select avg(balance) as Avg_balance, operation
from bank.trans
where k_symbol in (
  select k_symbol as symbol
  from (
    select avg(amount) as Average, k_symbol
    from bank.order
    where k_symbol <> ' '
    group by k_symbol
    having Average > 3000
    order by Average desc
  ) sub1
)
group by operation;

-- Step2: Now we want only the name of the operation that has the higher balance.
select operation from (
  select avg(balance) as Avg_balance, operation
  from bank.trans
  where k_symbol in (
    select k_symbol as symbol
    from (
      select avg(amount) as Average, k_symbol
      from bank.order
      where k_symbol <> ' '
      group by k_symbol
      having Average > 3000
      order by Average desc
    ) sub1
  )
  group by operation
) sub2
order by Avg_balance
limit 1;

/*		ACTIVITY
Find the most active customer for each district in Central Bohemia.
*/

-- -------------------------------
-- 	    CORRELATED SUBQUERIES
-- -------------------------------

-- We extracted the results only for those customers whose loan amount was greater than the average. 
-- Here is the self-contained subquery:

select * from bank.loan
where amount > (
  select avg(amount)
  from bank.loan
)
order by amount desc
limit 10;

-- Now we want to find those customers whose loan amounts are greater than the average 
-- but only within the same status group; 
-- ie. we want to find those averages by each group and 
-- simultaneously compare the loan amount of that customer with its status group's average.

select * from bank.loan l1
where amount > (
  select avg(amount)
  from bank.loan l2
  where l1.status = l2.status
)
order by amount desc;

-- --------------------------------
-- 	 			LAG
-- --------------------------------

-- Write a query to find the month on month monthly active users (MAU)
-- Use lag() function to get the active users in the previous month
-- To get this information we will proceed step by step.

-- Step 1: Get the account_id, date, year, month and month_number for every transaction.
use bank;

create or replace view user_activity as
select account_id, convert(date, date) as Activity_date,
date_format(convert(date,date), '%M') as Activity_Month,
date_format(convert(date,date), '%m') as Activity_Month_number,
date_format(convert(date,date), '%Y') as Activity_year
from bank.trans;

-- Checking the results
select * from bank.user_activity;

-- Step 2: Computing the total number of active users by Year and Month with group by 
-- and sorting according to year and month NUMBER.

select Activity_year, Activity_Month_number, count(account_id) as Active_users from bank.user_activity
group by Activity_year, Activity_Month_number
order by Activity_year asc, Activity_Month_number asc;

-- Step 3: Storing the results on a view for later use.

drop view bank.monthly_active_users;
create view bank.monthly_active_users as
select 
   Activity_year, 
   Activity_Month_number, 
   count(account_id) as Active_users 
from bank.user_activity
group by Activity_year, Activity_Month_number
order by Activity_year asc, Activity_Month_number asc;

-- Checking results
select * from monthly_active_users;

-- Step 4: Compute the difference of active_users between one month and the previous one 
-- for each year using the lag function with lag = 1 (as we want the lag from one previous record)

select 
   Activity_year, 
   Activity_Month_number,
   Active_users, 
   lag(Active_users,1) over (order by Activity_year, Activity_Month_number) as Last_month
from monthly_active_users;

-- Final step: Refining the query. Getting the difference of monthly active_users month to month.

with cte_view as (select 
   Activity_year, 
   Activity_Month_number,
   Active_users, 
   lag(Active_users,1) over (order by Activity_year, Activity_Month_number) as Last_month
from monthly_active_users)
select 
   Activity_year, 
   Activity_Month_number, 
   Active_users, 
   Last_month, 
   (Active_users - Last_month) as Difference 
from cte_view;


-- --------------------------------
-- 			SELF JOINS
-- --------------------------------

-- Number of retained users per month
-- So far we computed the total number of customers, 
-- but we are interested in the UNIQUE customer variation month to month. 
-- In other words, how many which unique customers keep renting from month to month? 
-- (customer_id present in one month and in the next one).


-- Step1: Getting the total number of UNIQUE active customers for each year-month.

select 
   distinct account_id as Active_id, 
   Activity_year, 
   Activity_month, 
   Activity_month_number 
from bank.user_activity;

-- Step 2: Create a view with the previous information

drop view bank.distinct_users;
create view bank.distinct_users as
select 
   distinct account_id as Active_id, 
   Activity_year, 
   Activity_month, 
   Activity_month_number 
from bank.user_activity;

-- Check results
select * from bank.distinct_users;

-- Final step: Do a cross join for the previous view but with the following restrictions:

-- The Active_id MUST exist in the second table
-- The Activity_month should be shifted by one.

select 
   d1.Activity_year,
   d1.Activity_month_number,
   count(distinct d1.Active_id) as Retained_customers
   from bank.distinct_users as d1
join bank.distinct_users as d2
on d1.Active_id = d2.Active_id 
and d2.Activity_month_number = d1.Activity_month_number + 1 
group by d1.Activity_year, d1.Activity_month_number
order by d1.Activity_year, d1.Activity_month_number;

-- Creating a view to store the results of the previous query

drop view if exists bank.retained_customers;
create view bank.retained_customers as 
select 
   d1.Activity_year,
   d1.Activity_month_number,
   count(distinct d1.Active_id) as Retained_customers
   from bank.distinct_users as d1
join bank.distinct_users as d2
on d1.Active_id = d2.Active_id 
and d2.Activity_month_number = d1.Activity_month_number + 1 
group by d1.Activity_year, d1.Activity_month_number
order by d1.Activity_year, d1.Activity_month_number;

-- Checking the final results
select * from bank.retained_customers;


-- SECOND EXAMPLE


-- Compute the change in retained customers from month to month. Again, let's go step by step.

-- Step 1: Checking what we have.

select * from retained_customers;

-- Step 2. Computing the differences between each month and restarted every year.
select 
   Activity_year,
   Activity_month_number,
   Retained_customers, 
   lag(Retained_customers, 1) over(partition by Activity_year) as Lagged
from retained_customers;

-- Final Step: Computing column differrences.
select
	Activity_year,
    Activity_month_number, 
    (Retained_customers-lag(Retained_customers, 1) over(partition by Activity_year)) as Diff
from retained_customers;

/*		
Use a similar approach to get total monthly transaction per account and the difference with the previous month.
*/

