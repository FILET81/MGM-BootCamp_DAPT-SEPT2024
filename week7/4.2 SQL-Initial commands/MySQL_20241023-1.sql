-- ------------------------------------------------------------------------
-- 							WELCOME TO SQL!!!
-- ------------------------------------------------------------------------

-- First things first: we can use "--" to comment lines (like this)
-- We can use /* */ to comment chunks:

/* like this
here it's still comment
no code
just comments
and here I close the comment section: */

-- ------------------------------------------------------------------------
-- 						Uploading bank database
-- ------------------------------------------------------------------------
/* 
	Download and open the "4.2-bank-mysql_dump.sql" and execute it. 
	This SQL file will create the database we will be using in the following classes.
	Be patient! It may take some time :)
*/

-- Which tables do we find?
-- How can we visualize the EER Diagram?

-- ------------------------------------------------------------------------
-- 				Exploring bank database - First SQL Commands
-- ------------------------------------------------------------------------

-- use bank; -- here we tell SQL which database we are going to be working on
-- select * from trans;
select * from bank.trans limit 10;

/* 
	It is a good practice to use the name of the database 
	followed by the name of the table since, as an analyst, 
	you might be working with multiple databases on a server.
*/

-- to select some columns instead of all
select trans_id, account_id, date, type
from bank.trans;

select bank.trans.trans_id, bank.trans.account_id, bank.trans.date, bank.trans.type
from bank.trans;

-- aliasing columns
select trans_id as Transaction_ID, account_id as Account_ID, date as Date, type as Type_of_account
from bank.trans;

-- aliasing columns and table
select bt.trans_id as Transaction_ID, bt.account_id as Account_ID, bt.date as Date, bt.type as Type
from bank.trans as bt;

-- limiting the number of rows in the results
select bt.trans_id as Transaction_ID, bt.account_id as Account_ID, bt.date as Date, bt.type as Type
from bank.trans as bt
limit 10;

-- check the number of records in a table
select count(*) from bank.trans;

-- ACTIVITY
/*
1. The select statement is used as a print command in SQL. 
	Use the select statement to print "Hello World".

2. Use the select statement to perform a simple mathematical calculation to add two numbers.
	
3. Use an appropriate select statement to retrieve a list of 
	unique card types from the bank database. (Hint: You can use DISTINCT function here.)
      
4. Get a list of all the district names in the bank database. 
	Suggestion is to use the files_for_activities/case_study_extended 
	here to work out which column is required here because we are looking 
	for the names of places, not just the IDs. 
	It would be great to see the results under the heading district_name. 
	(Hint: Use an alias.). You should have 77 rows.
       
Bonus: Revise your query to also show the Region, and limit the results to just 30 rows. 
Sort the results alphabetically by district name A>Z before selecting the 30.
*/

SELECT "Hello World" AS Welcome;
SELECT 4+5 AS Addition;
SELECT distinct(type) FROM bank.card;
SELECT distinct A2 AS district_name FROM bank.district;


-- -----------------------------------------
-- 				WHERE Commands
-- -----------------------------------------

select * from bank.order
where amount > 1000;

select * from bank.order
where k_symbol = 'SIPO';

select order_id, account_id, bank_to, amount from bank.order
where k_symbol = 'SIPO';

select order_id as 'OrderID', account_id as 'AccountID', 
	bank_to as 'DestinationBank', amount  as 'Amount'
from bank.order
where k_symbol = 'SIPO';

-- limiting results in the above query
select order_id as 'OrderID', account_id as 'AccountID', 
	bank_to as 'DestinationBank', amount  as 'Amount'
from bank.order
where k_symbol = 'SIPO'
limit 100;

/* ACTIVITY

1. Select districts and salaries (from the district table) where salary is greater than 10000. 
	Suggestion is to use the case study extended here
    to work out which columns are required here. 
    Return columns as district_name and average_salary.

2. Select those loans whose contract finished and were not paid.
	Hint: You should be looking at the loan column and 
    you will need the extended case study information to tell you which value of status is required.

3. Select cards of type junior. Return just first 10 in your query.

*/

SELECT A2 AS district_name, A11 AS average_salary FROM bank.district
WHERE A11 > 10000;


-- -----------------------------------------
-- 		Arithmetic and Comparison Commands
-- -----------------------------------------

/* Arithmetic operators in SQL:
- add (+), 
- subtract (-), 
- multiply (*), 
- divide (/), 
- modulo (%)
*/

select *, amount-payments as balance
from bank.loan;

select loan_id, account_id, date, duration, status, amount-payments as balance
from bank.loan;

select loan_id, account_id, date, duration, status, (amount-payments)/1000 as 'balance in Thousands'
from bank.loan;

-- this is the modulus operator that gives the remainder. This is a dummy example:
select duration%2
from bank.loan;

select 10%3;

/* Comparison operators in SQL: 
- equal to (=), 
- greater than (>), 
- less than (<), 
- greater than equal to (>=), 
- less than equal to (<=), 
- not equal to (<> or !=)

These comparison operators are used with the WHERE clause, for filtering data:
*/

select * from bank.loan
where status = 'B';
-- In this case status B is for those clients where the contract has finished but the loan is not paid yet

select * from bank.loan
where status in ('B','D');

select * from bank.loan
where status in ('B','b') and amount > 100000;

/* Limiting results in SQL (similar to head() in python data frames) */

select * from bank.loan
limit 10;

-- to get the bottom rows of a table, there is no predefined function
-- but you can sort the results in descending order and then use the LIMIT function

select * from bank.account
order by account_id 
limit 10;

-- In this case, we were able to do it because the data was arranged
-- in ascending order of the account_id

/* ACTIVITY
1. Select those loans whose contract finished and not paid back. 
	Return the debt value from the status you identified in the last activity, 
	together with loan_id and account_id.

2. Calculate the urban population for all districts.
	Hint: You are looking for the number of inhabitants and 
    the % of urban inhabitants in each district. 
    Return columns as district_name and urban_population.

3. On the previous query result - re-run it but filtering out districts 
	where the rural population is greater than 50%.
*/

-- -----------------------------------------
-- 			LOGICAL OPERATORS
-- -----------------------------------------

-- two conditions applied on the table
select *
from bank.loan
where status = 'B' and amount > 100000;

-- we can have as many conditions as we need
select *
from bank.loan
where status = 'B' and amount > 100000 and duration <= 24;

--
select *
from bank.loan
where status = 'B' or status = 'D';
-- Status B and D are the clients that were bad for business for the bank

select *
from bank.loan
where (status = 'B' or status ='D') and amount > 200000;

-- logical NOT operator - it negates the boolean expression that we are evaluating
select *
from bank.order
where not k_symbol = 'SIPO';

select *
from bank.order
where not k_symbol = 'SIPO' and not amount < 1000;

/* ACTIVITY

1. Get all junior cards issued last year.
	Hint: Use the numeric value (980000).

2. Get the first 10 transactions for withdrawals that are not in cash. 
	You will need the extended case study information to tell you 
    which values are required here, 
    and you will need to refer to conditions on two columns.

3. Refine your query from last activity on loans whose 
	contract finished and not paid back - filtered to loans 
	where they were left with a debt bigger than 1000. 
	Return the debt value together with loan_id and account_id. 
    Sort by the highest debt value to the lowest.
*/

-- -----------------------------------------
-- 			Numeric Functions
-- -----------------------------------------

select order_id, round(amount/1000,2)
from bank.order;

-- checking the number of rows in the table, both methods give the same result
-- given that there are no nulls in the column in the second case:
select count(*) from bank.order;

select count(order_id) from bank.order;

select max(amount) from bank.order;
select min(amount) from bank.order;

select floor(avg(amount)) from bank.order;
select ceiling(avg(amount)) from bank.order;

/* There are other numeric functions including 
 acos(), asin(), atan(), log(), log10(), power(), and sqrt(). */

-- -----------------------------------------
-- 			String Functions
-- -----------------------------------------

select length('himanshu');
select *, length(k_symbol) as 'Symbol_length' from bank.order;
select *, concat(order_id, account_id) as 'concat' from bank.order;

-- formats the number to a form with commas,
-- 2 is the number of decimal places, converts numeric to string as well
select *, format(amount, 2) from bank.loan;

select *, lower(A2), upper(A3) from bank.district;
-- It is interesting to note that select lower(A2), upper(A3), * from bank.district; doesn't work

select A2, left(A2,5), A3, ltrim(A3) from bank.district;
-- Similar to ltrim() there is rtrim() and trim(). And similar to left() there is right()

-- Splitting strings using substring_index
select issued, substring_index(issued, ' ', 1) from bank.card;

/* ACTIVITY
1. Get the biggest and the smallest transaction with non-zero values in the database 
	(use the trans table in the bank database).

2. Get account information with an extra column year showing 
	the opening year as 'YY'. Eg., 1995 will show as 95.
	Hint: Look at the first two characters of the string date in the account table.
*/