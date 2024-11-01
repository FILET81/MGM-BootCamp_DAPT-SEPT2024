/*
# Lab | SQL Queries 7

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

### Instructions

1. In the table actor, which are the actors whose last names are not repeated? For example if you would sort the data in the table actor by last_name,
you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name.
So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor "Angelina Astaire",
hence we would want this in our output list.
2. Which last names appear more than once? We would use the same logic as in the previous question, but this time we want to include the last names
of the actors where the last name was present more than once.
3. Using the rental table, find out how many rentals were processed by each employee.
4. Using the film table, find out how many films were released each year.
5. Using the film table, find out for each rating how many films were there.
6. What is the mean length of the film for each rating type. Round off the average lengths to two decimal places 
7. Which kind of movies (rating) have a mean duration of more than two hours?
*/

-- 1.
SELECT last_name FROM sakila.actor
GROUP BY last_name
HAVING count(last_name) = 1
ORDER BY last_name ASC;               -- Why it doesn't work when adding other columns like 'first_name' in SELECT or GROUP BY ?????

-- 2.
SELECT last_name FROM sakila.actor
GROUP BY last_name
HAVING count(last_name) != 1               -- It also works with <> !!!!!
ORDER BY last_name ASC;               -- Why it doesn't work when adding other columns like 'first_name' in SELECT or GROUP BY ?????

-- 3.
SELECT staff_id, count(rental_id) FROM sakila.rental
GROUP BY staff_id;

-- 4.
SELECT release_year, count(film_id) FROM sakila.film
GROUP BY release_year;               -- Why there's only 2006 in 'release_year'

-- 5.
SELECT rating, count(film_id) FROM sakila.film
GROUP BY rating
ORDER BY rating ASC;

-- 6.
SELECT rating, round(avg(length), 2) FROM sakila.film
GROUP BY rating
ORDER BY rating ASC;

-- 7.
SELECT rating, round(avg(length), 2) FROM sakila.film
GROUP BY rating
HAVING avg(length) > 120
ORDER BY rating ASC;