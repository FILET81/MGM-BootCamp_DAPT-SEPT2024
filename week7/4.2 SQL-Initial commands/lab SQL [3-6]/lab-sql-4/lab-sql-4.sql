/*
# Lab | SQL Queries 4

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

<br><br>

### Instructions

1. Get film ratings.
2. Get release years.
3. Get all films with ARMAGEDDON in the title.
4. Get all films with APOLLO in the title
5. Get all films which title ends with APOLLO.
6. Get all films with word DATE in the title.
7. Get 10 films with the longest title.
8. Get 10 the longest films.
9. How many films include **Behind the Scenes** content?
10. List films ordered by release year and title in alphabetical order.
*/

-- 1. Get film ratings.
SELECT distinct(rating) FROM sakila.film;

-- 2. Get release years.
SELECT distinct(release_year) FROM sakila.film;

-- 3. Get all films with ARMAGEDDON in the title.
SELECT title FROM sakila.film
WHERE title LIKE "%ARMAGEDDON%";

-- 4. Get all films with APOLLO in the title
SELECT title FROM sakila.film
WHERE title LIKE "%APOLLO%";

-- 5. Get all films which title ends with APOLLO.
SELECT title FROM sakila.film
WHERE title LIKE "%APOLLO";

-- 6. Get all films with word DATE in the title.
SELECT title FROM sakila.film
WHERE title LIKE "% DATE %"
	OR title LIKE "DATE %"
	OR title LIKE "% DATE"
    OR title = "DATE";

-- 7. Get 10 films with the longest title.
SELECT title FROM sakila.film
ORDER BY length(title) DESC
LIMIT 10;

-- 8. Get 10 the longest films.
SELECT title, length FROM sakila.film
ORDER BY length DESC
LIMIT 10;

-- 9. How many films include **Behind the Scenes** content?
SELECT count(film_id) FROM sakila.film               -- Possibility to also use SELECT count(distinct film_id) FROM sakila.film or SELECT count(*) FROM sakila.film !!!
WHERE special_features LIKE "%Behind the Scenes%";

-- 10. List films ordered by release year and title in alphabetical order.
SELECT title, release_year FROM sakila.film
ORDER BY release_year, title ASC;               -- No need to specify ASC order since it's the default value !!!!! 