use bank;
-- ----------------------------------------
-- 					DATETIME
-- ----------------------------------------
/* 
- Converting other data types to date, DateTime
- Changing formats of date columns using date_format() 
	-> info on datetime formats: https://www.w3schools.com/sql/func_mysql_date_format.asp
*/

/* 
Go through the case study pdf document to understand the format 
in which dates have been recorded in these tables - account, card, and loan.

In the first table, the column date is of type integer. 
So we will convert the column into date format. 
For now, this change will only be temporary as we not altering 
the structure of the table where the column has been defined.
*/
select account_id, district_id, frequency, date from bank.account;

select account_id, district_id, frequency, convert(date,date) from bank.account;

-- In the function, convert(), the first argument is the name of the column 
-- and the second is the type to which you want to convert. 
-- Similarly, we can do it for the loan table: 

select CONVERT(date,date) from bank.loan;

select account_id, district_id, frequency, CONVERT(date,datetime) from bank.account;

-- next is a two step process:
select issued from bank.card;
select substring_index(issued, ' ', 1) from bank.card;

select 
	convert(SUBSTRING_INDEX(issued, ' ', 1), date) 
from bank.card;

-- converting the original format to the date format that we need:
select date from bank.loan;
select date_format(convert(date,date), '%Y-%m-%d') from bank.loan;

-- if we just want to extract some specific part of the date
select date_format(convert(date,date), '%Y') from bank.loan;

/* 				ACTIVITY

1. Get card_id and year_issued for all gold cards.

2. When was the first gold card issued? (Year)

3. Get issue date as:
	date_issued: 'November 7th, 1993'
	fecha_emision: '07 of November of 1993'
*/

SELECT card_id, YEAR(CONVERT(SUBSTRING_INDEX(issued, ' ', 1), date)) FROM bank.card
WHERE (type = "gold");

SELECT min(cast(SUBSTRING_INDEX(issued, ' ', 1) AS date)) AS first_card FROM bank.card
WHERE (type = "gold");



-- ----------------------------------------
-- 		Logical order of processing
-- ----------------------------------------
/*
Even though if someone would read the SQL query, 
it is likely that they would think that the query 
is processed line after line from the beginning. 
But the way SQL reads the query is different:

1. FROM
2. ON
3. JOIN
4. WHERE
5. GROUP BY
6. WITH CUBE/ROLLUP
7. HAVING
8. SELECT
9. DISTINCT
10. ORDER BY
11. TOP/LIMIT
12. OFFSET/FETCH

More info: https://www.itprotoday.com/sql-server/logical-query-processing-what-it-and-what-it-means-you

Ejemplo: 

5 SELECT 5.2 DISTINCT 7 TOP 
    5.1 
1 FROM 
2 WHERE 
3 GROUP BY 
4 HAVING 
6 ORDER BY 
7 OFFSET  FETCH 
*/

select * 
from bank.card
where type = 'classic'
order by card_id
limit 10;

select * 
from bank.order
where k_symbol = 'SIPO' and amount > 5000
order by order_id desc
limit 10;


-- ----------------------------------------
-- 				NULL Values
-- ----------------------------------------
/*
A common mistake that people make is to use the term NULL value 
but a NULL is not a value; rather, it’s a mark for a missing value. 
So the correct terminology is either NULL mark or just NULL. 
Also, because SQL uses only one mark for missing values, 
when you use a NULL, there is no way for SQL to know whether 
it is supposed to represent a missing and applicable case or 
a missing and inapplicable case.
*/
select isnull('Hello');
select isnull(card_id) from bank.card;

-- this is used to check all the elements of a column.
-- 0 means not null, 1 means null
select sum(isnull(card_id)) from bank.card;

select * from bank.order
where k_symbol is null;

select * from bank.order;

/*As you might have noticed in this case, 
even though we see a lot of missing values in the column k_symbol, 
the above query does not filter those rows. 
It might be because those columns actually have value, 
for example, empty space. 
SQL considers that as a character/ value as well. 
So we will check for that now:
*/

select count(*) from bank.order
where k_symbol is not null and k_symbol = ' ';

/*				ACTIVITY
1. Null or empty values are usually a problem. 
   Think about why those null values can appear and think of ways of dealing with them.

2. Check for transactions with null or empty values for the column amount.

3. Count how many transactions have empty and non-empty k_symbol (in one query).
*/

/*
The possible values of a predicate in SQL are TRUE, FALSE and UNKNOWN. 
This is referred to as three-valued logic and is unique to SQL. 
Logical expressions in most programming languages can be only TRUE or FALSE. 
The UNKNOWN logical value in SQL typically occurs in a logical expression 
that involves a NULL. For example, the logical value of each of these 
three expressions is UNKNOWN:

	NULL > 1759;
	NULL = NULL;
	X + NULL > Y

*/
-- ----------------------------------------
-- 				Case Statements
-- ----------------------------------------

/*
	In the loan table, there's column status A, B, C, and D. 
	Using the case statement we will try to replace the values 
	there with a brief description.
*/

select loan_id, account_id,
case
	when status = 'A' then 'Good - Contract Finished'
	when status = 'B' then 'Defaulter - Contract Finished'
	when status = 'C' then 'Good - Contract Running'
	else 'In Debt - Contract Running'
end as 'Status_Description'
from bank.loan;