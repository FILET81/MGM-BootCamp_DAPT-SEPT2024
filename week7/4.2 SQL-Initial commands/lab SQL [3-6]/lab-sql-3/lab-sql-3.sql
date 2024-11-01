/*
# Lab | SQL Queries 3

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

<br><br>

### Instructions

1. How many distinct (different) actors' last names are there?
2. In how many different languages where the films originally produced? (Use the column `language_id` from the `film` table)
3. How many movies were released with `"PG-13"` rating?
4. Get 10 the longest movies from 2006.
5. How many days has been the company operating (check `DATEDIFF()` function)?
6. Show rental info with additional columns month and weekday. Get 20.
7. Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week.
8. How many rentals were in the last month of activity?
*/

-- 1. How many distinct (different) actors' last names are there?
SELECT count(distinct last_name) FROM sakila.actor;

-- 2. In how many different languages where the films originally produced? (Use the column `language_id` from the `film` table)
SELECT count(distinct language_id) FROM sakila.film;

-- 3. How many movies were released with `"PG-13"` rating?
SELECT count(distinct film_id) FROM sakila.film
WHERE rating = "PG-13";               -- Possibility to also use "title" from the table, although it's not the PK. Better to use distinct for a more accurate output?

-- 4. Get 10 the longest movies from 2006.
SELECT title, length FROM sakila.film
WHERE release_year = 2006
ORDER BY length DESC
LIMIT 10;

-- 5. How many days has been the company operating (check `DATEDIFF()` function)?
SELECT datediff(max(rental_date), min(rental_date)) FROM sakila.rental;               -- What if "operating days" = first day of rental until last day of return ?????

-- 6. Show rental info with additional columns month and weekday. Get 20.
SELECT *, month(rental_date) AS "month_rental_date"
, weekday(rental_date) AS "weekday_rental_date"
, month(return_date) AS "month_return_date"  
, weekday(return_date) AS "weekday_return_date"
FROM sakila.rental
LIMIT 20;

-- 7. Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *,
CASE
	WHEN dayofweek(rental_date) IN (7,1) THEN "weekend"               -- Same output with weekday(); but here, Saturday = 5 and Sunday = 6 !!!!!
	ELSE "workday"                                                    -- Why it doesn't work with WHEN dayofweek(rental_date) = 1 OR 7 THEN "weekend" ?????
END AS "day_type"                                                     -- Should it work with WHEN dayofweek(rental_date) = 1 OR dayofweek(rental_date) = 7 THEN "weekend" ?????
FROM sakila.rental;

-- 8. How many rentals were in the last month of activity?
SELECT count(rental_id) AS "rentals_last_month" FROM sakila.rental               -- Assuming that last month = last 30 days !!!!!
WHERE rental_date >= (SELECT max(rental_date) FROM sakila.rental) - INTERVAL 30 DAY;

-- 8. How many rentals were in the last month of activity? (option 2)
SELECT extract(YEAR_MONTH from rental_date), count(*) FROM sakila.rental
group by extract(YEAR_MONTH from rental_date)
order by extract(YEAR_MONTH from rental_date) DESC LIMIT 1;