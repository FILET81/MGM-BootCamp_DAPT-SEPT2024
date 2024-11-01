-- ----------------------------------------
-- 			Aggregation Functions			
-- ----------------------------------------
/*
Aggregation functions available in SQL:
	- avg(), 
    - sum(), 
    - min(),       It accepts strings too !!!!!
    - max(),       It accepts strings too !!!!!
    - count()
    
Mathematical operators and functions used in the previous lessons 
were scalar functions as they operate on a single value and return a single value. 
However, the aggregation functions act on a series of values 
and return a single summary value. Aggregation functions are sometimes 
called column functions as they operate on a series of values in a column. 
A query that contains one or more aggregate functions is also called a summary query.
*/

-- What is the total amount loaned by the bank so far?
select sum(amount) from bank.loan;

-- What is the total amount that the bank has recovered/received from the customers?
select sum(payments) from bank.loan;

-- What is the average loan amount taken by customers in Status A?
select avg(amount) AS "Mean" from bank.loan
where Status = 'A';


-- ----------------------------------------
-- 				GROUP BY
-- 			  one variable
-- ----------------------------------------

-- Revisiting the last query we did, now using GROUP BY. 
-- In this query, we will try to find out the average balances for the different statuses of people who have taken loans:

-- step1:
select 
	status
    , round(avg(amount),2) as "Avg Amount"
    , round(avg(payments),2) as "Avg Payment"
from bank.loan
group by status
order by status;

-- step1:
select 
	status
    , round(avg(amount),2) as "Avg Amount"
    , round(avg(payments),2) as "Avg Payment"
from bank.loan
group by status
order by round(avg(payments), 2) DESC;

-- step1:
select 
	status
    , duration
    , round(avg(amount),2) as "Avg Amount"
    , round(avg(payments),2) as "Avg Payment"
from bank.loan
group by status, duration
order by round(avg(payments), 2) DESC;

-- step 2:
select round((avg(amount) - avg(payments)),2) as "Avg Balance", status
from bank.loan
group by status
order by status;       -- The output is the same as below !!!!!

select round(avg(amount-payments),2) as "Avg Balance", status
from bank.loan
group by status
order by status;       -- The output is the same as above !!!!!

-- step 2:
select 
	round((avg(amount) - avg(payments)),2) as "Avg Balance"
    , sum(case when duration = 60 then 1 else 0 end) AS nr_60_months_duration
    , status
from bank.loan
group by status
order by status;

-- Now use the bank.order table.
-- Find the average amount of transactions for each different kind of k_symbol.

select round(avg(amount),2) as Average, k_symbol 
from bank.order
group by k_symbol
order by Average asc;

-- As you can see, whichever k_symbol was empty, those values were also aggregated. 
-- We can remove those values by using a simple filter on it.

select round(avg(amount),2) as Average, k_symbol 
from bank.order
where k_symbol<> ' '
group by k_symbol
order by Average asc;

-- ❗ Note: Apply the same filter using the NOT filter.
-- The same query with NOT operator.

select round(avg(amount),2) as Average, k_symbol from bank.order
where not k_symbol = ' '
group by k_symbol
order by Average asc;

/* 		ACTIVITY
1. Find out how many cards of each type have been issued.
2. Find out how many customers there are by the district.
3. Find out average transaction value by type.
*/

-- 1.
SELECT type, count(type) FROM bank.card               -- count(column) counts non-NULLs only !!!!!
GROUP BY type;

SELECT type, count(*) FROM bank.card               -- count(*) may be a better option, since it includes all rows (also NULLs) !!!!! (it doesn't affect here, because of the "group by")
GROUP BY type;

-- 2.
SELECT A2, sum(A4) FROM bank.district
GROUP BY A2;               -- Bad idea !!!!!

SELECT district_id, count(*) FROM bank.client
GROUP BY district_id
ORDER BY count(*);               -- This approach is better !!!!!

-- 3. 
SELECT type, round(avg(amount), 2) FROM bank.trans
GROUP BY type
ORDER BY avg(amount) DESC;


-- ----------------------------------------
-- 				GROUP BY
-- 		  	  two variables
-- ----------------------------------------
-- We will keep building on the example we used before. 
-- Now, we want to deep dive based on months as well:

select round(avg(amount),2) - round(avg(payments),2) as "Avg Balance", status, duration
from bank.loan
group by status, duration               -- Order doesn't matter in GROUP BY !!!!!
order by status, duration;               -- Order does matter in ORDER BY !!!!!

-- Emphasize on the order used in the ORDER BY clause. 

select round(avg(amount),2) - round(avg(payments),2) as "Avg Balance", duration, status 
from bank.loan
group by status, duration
order by duration, status;

-- You can add more layers with the GROUP BY clause to further group the data based on multiple columns. 

-- For this example, we will take a look at the transaction table in the database. 
-- We want to analyze the average balance based on the type, operation and k_symbol fields:

-- Query without the "order by" clause
select type, operation, k_symbol, round(avg(balance),2)
from bank.trans
group by type, operation, k_symbol;

-- Query with the "order by" clause
select type, operation, k_symbol, round(avg(balance),2)
from bank.trans
group by type, operation, k_symbol
order by type, operation, k_symbol;

/*		ACTIVITY
As you might have seen in the previous query, there are 15 rows returned by this query. 
But there are few places where the column k_symbol is an empty string. 
Your task is to use a filter to remove those rows of data. 
After the filter gets applied, you would see that the number of rows have reduced.
*/


-- ----------------------------------------
-- 			GROUP BY, HAVING
-- ----------------------------------------
/*
Discussion: WHERE vs. HAVING clause

WHERE clause is used to apply the condition to the rows before the aggregation, 
while HAVING clause is used to apply the condition after the data has been aggregated. 
We will try to explain the difference through the next example.
*/

select type, operation, k_symbol, round(avg(balance),2) as Average
from bank.trans
where k_symbol <> '' and k_symbol <> ' ' and  operation <> ''
group by type, operation, k_symbol
having Average > 30000
order by type, operation, k_symbol;

-- As you can see, the filter using the HAVING clause was applied to the aggregated column. 
-- A regular filter can be used, just like the WHERE clause; but that is not an efficient way of using the HAVING clause. 
-- It is shown in the example below.

-- Not the most efficient way of using the HAVING clause:

select type, operation, k_symbol, round(avg(balance),2) as Average
from bank.trans
where k_symbol <> '' and k_symbol <> ' '
group by type, operation, k_symbol
having operation <> ''       -- Empty, string, and not NULL
order by type, operation, k_symbol;


-- Now using the same query as before:

select round(avg(amount),2) - round(avg(payments),2) as Avg_Balance, status, duration
from bank.loan
group by status, duration
having Avg_Balance > 100000
order by duration, status;

/*			ACTIVITY
1. Find the districts with more than 100 clients.
2. Find the transactions (type, operation) with a mean amount greater than 10000.
*/

-- 1.
SELECT district_id, count(*) FROM bank.client
GROUP BY district_id
HAVING count(*) > 100
ORDER BY count(*) DESC;

-- 2.
SELECT type, operation, avg(amount) FROM bank.trans
GROUP BY type, operation
HAVING avg(amount) > 10000;


-- ----------------------------------------
-- 			WINDOW FUNCTIONS
-- ----------------------------------------
/*
Window functions also operate on a subset, but they do not reduce the target to a single value. 
They operate on a window which is specified by PARTITION BY(). 
As you will see in the query, we are trying to compare individual balances with
the average balance for that particular duration of the loan. 
This would be very difficult and complicated to get using a GROUP BY clause.
*/

select loan_id, account_id, amount, payments, duration, amount-payments as "Balance",
round(avg(amount-payments) over(partition by duration), 2) as Avg_Balance
from bank.loan
where amount > 100000               -- Note that HAVING clause is not used when applying Window functions !!!!!
order by duration, balance desc;               -- MySQL is not case sensitive !!!!!

-- You can use other aggregation functions as required. 
-- It is important to note that, even though the column "Avg_Balance" is aggregated, you can't apply the HAVING clause
-- to this column unlike with a GROUP BY clause !!!!!
-- You can use the results of this query as a subquery and then use these results as a table itself. 


-- The goal is to rank the customers based on the amount of loan borrowed.
-- This will help us to find the nth highest amount in the table.

select *, rank() over(order by amount desc) as 'Rank'
from bank.loan;

-- Note that we have not used the PARTITION BY clause here; thus, we are not working on any Window function !!!!! 
-- We are just trying to rank the data. We can achieve the same results with row_number() as well, as shown below:

select *, row_number() over(order by amount desc) as 'Row Number'
from bank.loan;

-- In the following query, we are trying to rank the customers based on the amount of loan they have borrowed,
-- in each of the "k_symbol" categories.

select *, rank() over(partition by k_symbol order by amount desc) as "Ranks"
from bank.order
where k_symbol <> " ";

-- DIFFERENCES:

select *, row_number() over(order by amount asc) as 'Row Number',
dense_rank() over(order by amount asc) as 'Dense Rank',
rank() over(order by amount asc) as 'Rank'
from bank.order
where k_symbol <> ' ';

-- While using RANK, the ties are assigned the same rank and the next ranking is skipped !!!!!
-- However, with DENSE_RANK you get consecutive ranks without any skips !!!!!

/*		ACTIVITY
In this activity, we will be using the table district from the bank database, 
and according to the description for the different columns:

A4: no. of inhabitants
A9: no. of cities
A10: the ratio of urban inhabitants
A11: average salary
A12: the unemployment rate

1. Rank districts by different variables.
2. Do the same but group by region.
*/
