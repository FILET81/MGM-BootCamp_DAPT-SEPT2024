use bank;
-- ----------------------------------------
-- 			DISTINCT, IN, BETWEEN
-- ----------------------------------------
/*
- Removing duplicate rows with DISTINCT
- Using IN operator
- Using BETWEEN
*/
select A3 from bank.district;

select distinct A3 from bank.district;

select * from bank.order
where k_symbol in ('leasing', 'pojistine');

/*
When using comparison operators in MySQL, they are not case sensitive,
which means 'LEASING' and 'leasing' will be evaluated as equal.
*/

select * from bank.account
where district_id in (1,5,3,2,4);       -- in () used with integers, but usually not with floats

-- We are trying to get the same result using the between operator.
-- Note that 1 and 5 are included in the range of values compared/evaluated

select * from bank.account
where district_id between 1 and 5;       -- between used more with floats

select * from bank.loan
where amount - payments between 1000 and 10000;

/*			ACTIVITY
Keep working on the bank database and its card table.

1. Get different card types.
2. Get transactions in the first 15 days of 1993.
3. Get all running loans.

*/

-- 1.
SELECT distinct type FROM bank.card;
-- 2.
SELECT * FROM bank.trans
WHERE date between 930101 and 930115;
-- 2. (option 2)
SELECT * FROM bank.trans
WHERE LEFT(date,4) = '9301' AND cast(RIGHT(date,2) as float) BETWEEN 1 AND 15;
-- 3.
SELECT * FROM bank.loan
WHERE status IN  ("C", "D");

-- ----------------------------------------
-- 				LIKE, REGEXP
-- ----------------------------------------

select * from bank.district
where A3 like 'north%';

select * from bank.district
where a3 like 'north_M%';
-- This would not return all the results for 'north  Moravia', 'northMoravia', northMiami'

-- How is the result changed if we use % instead of _ in the previous query? 
select * from bank.district
where a3 regexp 'north';

-- Now we will take a look at another table, to see the difference between LIKE and REGEXP
select * from bank.order
where k_symbol regexp 's';

select * from bank.order
where k_symbol regexp '^s';

select * from bank.order
where k_symbol regexp 'o$';

-- We can include multiple conditions at the same time
select distinct k_symbol from bank.order
where k_symbol regexp 'ip|is';

-- --------
select * from bank.district
where a2 regexp 'cesk[eya]';

select * from bank.district
where a2 regexp 'ch[e-z]';

/*
Note: LIKE and REGEXP operators significantly degrade the performance 
of query execution as compared to simple comparison operators. 
One should be careful when using them.
*/

-- 				ACTIVITY

-- 1. Can you use the following query:
	select * from bank.district
	where a3 like 'north%M%';

-- instead of:
	select * from bank.district
	where a3 like 'north_M%';

-- Try both the queries and check the results.

-- 2. We looked at the following query in class:
	select * from bank.district
	where a2 regexp 'ch[e-r]';
-- Can you modify the query to print the rows only for those values in the A2 column that starts with 'CH'?
	select * from bank.district
	where a2 regexp '^ch[e-r]';
    -- or
	select * from bank.district
	where a2 LIKE 'ch%';

/* 3. Use the table trans for this query. 
Use the column type to test: "By default, 
in an ascending sort, special characters appear first, 
followed by numbers, and then letters."*/

SELECT distinct type FROM bank.trans;       -- Question not correct !!!!!

/*4. Again use the table trans for this query. 
Use the column k_symbol to test: 
"Null values appear first if the order is ascending."*/

SELECT distinct k_symbol FROM bank.trans;       -- Question not correct !!!!!

/*5. Pick any table and any column to test: 
"You can use any column from the table to sort the values 
even if that column is not used in the select statement." 
Check the difference by writing the query with and without that column 
(column used to sort the results) in the select statement.
*/


-- ----------------------------------------
-- 				ORDER BY
-- ----------------------------------------

select distinct a2 from bank.district
order by a2;

select distinct a2 from bank.district
order by a2 desc;

select distinct a2 from bank.district
order by length(a2) desc;       -- order by can be used with a function !!!!!

select * from bank.district
order by a3;

select * from bank.district
order by a2, a3;

select * from bank.district
order by a3 desc, a7, a5 desc;       -- order affects the final output !!!!!

select *, year(date) as loan_year, month(date) as loan_month from bank.loan
order by year(date), month(date);

/*
Note that, by default, (if not specified) the order is ascending.
By default, in an ascending sort, special characters appear first, 
followed by numbers, and then letters.
Null values appear first if the order is ascending.
You can use any column from the table to sort the values 
even if that column is not used in the select statement.
*/

select * from bank.order
order by account_id, bank_to;

select * from bank.order
order by account_id, bank_to, k_symbol;
