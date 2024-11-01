/*
# Lab | SQL Intro

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You can follow the steps listed here to get the data locally: [Sakila sample database - installation](https://dev.mysql.com/doc/sakila/en/sakila-installation.html). You can work with two sql query files - `sakila-schema.sql` (creates the schema) + `sakila-data.sql` which inserts the data.

The ERD is pictured below - not all tables are shown, but many of the key fields you will be using are visible:

<br>

![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

<br><br>

### Instructions

1. Use sakila database.
2. Get all the data from tables `actor`, `film` and `customer`.
3. Get film titles.
4. Get unique list of film languages under the alias `language`. Note that we are not asking you to obtain the language per each film, but this is a good time to think about how you might get that information in the future.
5.
  - 5.1 Find out how many stores does the company have?
  - 5.2 Find out how many employees staff does the company have? 
  - 5.3 Return a list of employee first names only?

6. Select all the actors with the first name ‘Scarlett’.
7. Select all the actors with the last name ‘Johansson’.
8. How many films (movies) are available for rent?
9. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
10. What's the average movie duration?
11. How many movies are longer than 3 hours?
12. What's the length of the longest film title?
*/

-- 1. Use sakila database
use sakila;

-- 2. Get all the data from tables `actor`, `film` and `customer`.
SELECT * FROM sakila.actor, sakila.film, sakila.customer
LIMIT 10000;               -- limit used in order to get the whole output; otherwise, it's limited to 1000 rows. 

-- 3. Get film titles.
SELECT title FROM sakila.film;

/* 4. Get unique list of film languages under the alias `language`. 
Note that we are not asking you to obtain the language per each film, but this is a good time 
to think about how you might get that information in the future. */
SELECT name AS "language" FROM sakila.language; 

-- 5.1 Find out how many stores does the company have?
SELECT count(store_id) FROM sakila.store;
-- 5.2 Find out how many employees staff does the company have?
SELECT count(staff_id) FROM sakila.staff;
-- 5.3 Return a list of employee first names only?
SELECT first_name FROM sakila.staff;

-- 6. Select all the actors with the first name ‘Scarlett’.
SELECT actor_id FROM sakila.actor
WHERE first_name = "Scarlett";               -- Why NULL values appear in the output?

-- 7. Select all the actors with the last name ‘Johansson’.
SELECT actor_id FROM sakila.actor
WHERE last_name = "Johansson";               -- Why NULL values appear in the output?

-- 8. How many films (movies) are available for rent?
SELECT count(inventory_id) FROM sakila.inventory;               -- Same output by using "film_id" from the same table; although it's a FK in such a table.

-- 9. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT max(length) AS "max_duration", min(length) AS "min_duration" FROM sakila.film;

-- 10. What's the average movie duration?
SELECT avg(length) FROM sakila.film;

-- 11. How many movies are longer than 3 hours?
SELECT count(film_id) FROM sakila.film
WHERE length > 180;

-- 12. What's the length of the longest film title?
SELECT max(length(title)) FROM sakila.film;