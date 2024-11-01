-- ----------------------------------------
-- 					JOINS
-- ----------------------------------------

select * from bank.account a
join bank.loan l on a.account_id = l.account_id
limit 10;

-- Note that in the query below, we have used the alias for columns on which we have used WHERE and ORDER BY clause. 
-- It is not necessary in this case, as there would be no conflict for MySQL since the columns duration and payments
-- are only present in table loan. 
-- Aliases are used to remove the ambiguity in case the column names are the same !!!!!
-- It is also a good practice that one should follow.

-- Building on the same query to add some filters and order by
select * from bank.account a
join bank.loan l on a.account_id = l.account_id
where l.duration = 12
order by l.payments
limit 10;

-- Using an Alias to select some columns
select a.account_id, a.frequency, l.loan_id, l.amount, l.duration, l.payments, l.status
from bank.account a
join bank.loan l on a.account_id = l.account_id
where l.duration = 12
order by l.payments
limit 10;

-- Some test code
select count(distinct account_id) from bank.account;
select count(distinct account_id) from bank.loan;
-- As you can see, there is a difference in the output from the two queries (4500 vs 682 !!!). 
-- Hence, we can say that not all the account_ids have information available from the order (other?) table. 
-- Or, we can say that not all the customers have taken a loan from the bank.

-- LEFT Join
select a.account_id, a.frequency, l.loan_id, l.amount, l.duration, l.payments, l.status
from bank.account a
left join bank.loan l on a.account_id = l.account_id
order by a.account_id;
-- Note: Since this is a LEFT join, all the rows from the table on the left are selected for sure. 
-- Hence, the result has the same number of rows as the number of rows in the account table. 
-- We can verify that by using select count(*) from table name query.

-- RIGHT Join
select a.account_id, a.frequency, l.loan_id, l.amount, l.duration, l.payments, l.status
from bank.account a
right join bank.loan l on a.account_id = l.account_id
order by a.account_id;
-- Note: Again, since this is a RIGHT join, all the rows from the table on the right are selected for sure. 
-- Hence, the result has the same number of rows as the number of rows in the loan table. 
-- We can verify that by using select count(*) from table name query.


/*		ACTIVITY
1. Get a rank of districts ordered by the number of customers.
2. Get a rank of regions ordered by the number of customers.
3. Get the total amount borrowed by the district together with the average loan in that district.
4. Get the number of accounts opened by district and year.
*/


-- ----------------------------------
-- 			  INNER Join
-- ----------------------------------
-- Write a query to extract information from the loan and the account tables to get information for all accounts.

select * from bank.account a join bank.loan l on a.account_id = l.account_id; 

select * from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select l.loan_id, l.account_id, l.amount, l.payments, a.district_id, a.frequency, a.date
from bank.loan l
join bank.account a
on l.account_id = a.account_id;


-- ----------------------------------
-- 		    LEFT OUTER Join
-- ----------------------------------

select * from bank.loan l
left join bank.account a
on l.account_id = a.account_id;

select * from bank.account a
left join bank.loan l
on a.account_id = l.account_id;
-- ❗ Note: You will notice there is a big difference in the output of these queries. 


-- ----------------------------------
-- 		    RIGHT OUTER Join
-- ----------------------------------
-- In the next two queries we have just changed the keyword from 'left' to 'right'.

select * from bank.account a
right join bank.loan l
on a.account_id = l.account_id;

select * from bank.loan l
right join bank.account a
on l.account_id = a.account_id;
-- ❗ Note: You will notice there is a big difference in the output of these queries.
 

-- ----------------------------------
-- 		   MORE USES
-- ----------------------------------
-- Write a query to extract information from the client and the district tables to get information for
-- all the clients of the city, and region they are from.

-- Step 1
select * from bank.client c join bank.district d
on c.district_id = d.A1;

-- Step 2
select c.client_id, c.birth_number, c.district_id, d.A2, d.A3
from bank.client c join bank.district d
on c.district_id = d.A1;

-- Write queries to extract information about the accounts:
-- 		a) returning account_id, operation, frequency, sum of amount, sum of balance, 
-- 		b) where the balance is over 1000, 
-- 		c) operation type is VKLAD and 
-- 		d) that have an aggregated amount of over 500,000.

-- step 1
select * from bank.trans t
left join bank.account a
on t.account_id = a.account_id;

-- step 2
select * from bank.trans t left join bank.account a on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000;

-- step 3
select t.account_id, t.operation, a.frequency, sum(amount) as TotalAmount, sum(balance) as TotalBalance
from bank.trans t left join bank.account a on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000
group by t.account_id, t.operation, a.frequency;

-- step 4
select t.account_id, t.operation, a.frequency, sum(t.amount) as TotalAmount, sum(balance) as TotalBalance
from bank.trans t left join bank.account a on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000
group by t.account_id, t.operation, a.frequency
having TotalAmount > 500000
order by TotalAmount desc
limit 10;


/* 			ACTIVITY
1. Make a list of all the clients together with region and district, ordered by region and district.

2. Count how many clients do we have per region and district.
	2.1 How many clients do we have per 10000 inhabitants?
*/


-- ----------------------------------
-- 	   JOIN with MULTIPLE TABLES
-- ----------------------------------
-- Demo of how to extract all the information from three tables (disp, client, and card). 
-- Get all the columns from 3 tables 

select * from bank.disp d
join bank.card ca
on d.disp_id = ca.disp_id
join bank.client c
on d.client_id = c.client_id;

select * from bank.disp;

select d.disp_id, d.type, d.client_id, c.birth_number, ca.type from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.card ca
on d.disp_id = ca.disp_id
where ca.type = 'gold';


-- ACTIVITY: List districts together with total amount borrowed and average loan amount.


-- ----------------------------------
-- 	   CREATE TEMPORARY TABLES
-- ----------------------------------

create temporary table bank.loan_and_accounts               -- First Example
select l.loan_id, l.account_id, a.district_id, l.amount, l.payments, a.frequency
from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select * from bank.loan_and_accounts;

create temporary table bank.disp_and_account               -- Second Example
select d.disp_id, d.client_id, d.account_id, a.district_id, d.type
from bank.disp d
join bank.account a
on d.account_id = a.account_id;

select * from bank.disp_and_account;


-- ------------------------------------------
-- 	COMPOUND CONDITIONS with JOIN STATEMENTS
-- ------------------------------------------

select * from bank.loan_and_accounts la
join bank.disp_and_account da
on la.account_id = da.account_id
and la.district_id = da.district_id;


-- ACTIVITY: Create a temporary table district_overview in the bank database which lists districts together with total amount borrowed and average loan amount.


-- ------------------------------------------
-- 	       MORE ON MULTIPLE JOINS
-- ------------------------------------------

select a.account_id, a.district_id, a.frequency, d.A2, d.A3, l.loan_id, l.amount, l.payments
from bank.account a left join bank.district d
on a.district_id = d.A1
left join bank.loan l
on a.account_id = l.account_id
order by a.account_id;

-- ❗ Note: Break down the query into two steps. 
-- The first step is the join between the account and the district tables. 
-- The second step is the join between (account and district) and loan tables. 
-- Then check how the left outer join is giving out those NULL values (not every customer in the bank has taken a loan).

-- Notice the difference in the results if we remove the keyword left from the query above. 
-- The query with only inner joins for the same tables as above is shown below:

select a.account_id, a.district_id, a.frequency, d.A2, d.A3, l.loan_id, l.amount, l.payments
from bank.account a join bank.district d
on a.district_id = d.A1
join bank.loan l
on a.account_id = l.account_id
order by a.account_id;
