/*
# Lab | SQL Queries 8

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

### Instructions

1. Rank films by length (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length and rank.
2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length, rating and rank.  
3. How many films are there for each of the categories in the category table? **Hint**: Use appropriate join between the tables "category" and "film_category".
4. Which actor has appeared in the most films? **Hint**: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
5. Which is the most active customer (the customer that has rented the most number of films)? **Hint**: Use appropriate join between the tables "customer" and "rental" and count the `rental_id` for each customer.
6. List the number of films per category.
7. Display the first and the last names, as well as the address, of each staff member.
8. Display the total amount rung up by each staff member in August 2005.
9. List all films and the number of actors who are listed for each film.
10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer. List the customers alphabetically by their last names.
11. Write a query to display for each store its store ID, city, and country.
12. Write a query to display how much business, in dollars, each store brought in.
13. What is the average running time of films by category?
14. Which film categories are longest?
15. Display the most frequently rented movies in descending order.
16. List the top five genres in gross revenue in descending order.
17. Is "Academy Dinosaur" available for rent from Store 1?
*/

-- 1. Rank films by length (filter out the rows with nulls or zeros in length column).
SELECT title, length, rank() over(ORDER BY length) as "Rank" 
FROM sakila.film
WHERE length IS NOT NULL or length <> 0;

SELECT title, length, dense_rank() over(ORDER BY length) as "Dense Rank" 
FROM sakila.film
WHERE length IS NOT NULL or length <> 0;


-- 2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column).
SELECT title, length, rating, rank() over(PARTITION BY rating ORDER BY length) as "Rank" 
FROM sakila.film
WHERE length IS NOT NULL or length <> 0;

SELECT title, length, rating, dense_rank() over(PARTITION BY rating ORDER BY length) as "Dense Rank" 
FROM sakila.film
WHERE length IS NOT NULL or length <> 0;


-- 3. How many films are there for each of the categories in the category table?
SELECT * FROM sakila.film_category;               -- Used to check data
SELECT * FROM sakila.category;               -- Used to check data

-- Step 1
SELECT * FROM sakila.film_category l
JOIN sakila.category a               -- Inner Join
ON l.category_id = a.category_id;
-- Step 2
SELECT a.category_id, a.name, count(l.film_id) FROM sakila.film_category l JOIN sakila.category a ON l.category_id = a.category_id
GROUP BY a.category_id, a.name
ORDER BY count(l.film_id) DESC;


-- 4. Which actor has appeared in the most films?
SELECT * FROM sakila.actor;               -- Used to check data
SELECT * FROM sakila.film_actor;               -- Used to check data

-- Step 1
SELECT * FROM sakila.actor l
JOIN sakila.film_actor r               -- Inner Join
ON l.actor_id = r.actor_id;
-- Step 2
SELECT l.actor_id, l.first_name, l.last_name, count(r.film_id) AS "actor_more_films" FROM sakila.actor l JOIN sakila.film_actor r ON l.actor_id = r.actor_id
GROUP BY l.actor_id
ORDER BY count(r.film_id) DESC;


-- 5. Which is the most active customer (the customer that has rented the most number of films)?
SELECT * FROM sakila.customer;               -- Used to check data
SELECT * FROM sakila.rental;               -- Used to check data

-- Step 1
SELECT * FROM sakila.customer cr
JOIN sakila.rental re
ON cr.customer_id = re.customer_id;
-- Step 2
SELECT cr.customer_id, cr.first_name, cr.last_name, count(re.rental_id) AS "most_active_customer" FROM sakila.customer cr JOIN sakila.rental re ON cr.customer_id = re.customer_id
GROUP BY cr.customer_id
ORDER BY count(re.rental_id) DESC;


-- 6. List the number of films per category.
SELECT x.category_id, y.name, count(x.film_id) AS "films_count" FROM sakila.film_category x JOIN sakila.category y ON x.category_id = y.category_id
GROUP BY x.category_id
ORDER BY count(x.film_id) DESC;


-- 7. Display the first and the last names, as well as the address, of each staff member.
SELECT l.first_name, l.last_name, r.address
FROM sakila.staff l 
JOIN sakila.address r 
ON l.address_id = r.address_id;


-- 8. Display the total amount rung up by each staff member in August 2005.
SELECT * FROM sakila.staff;               -- Used to check data
SELECT * FROM sakila.payment;               -- Used to check data

-- Step 1
SELECT * 
FROM sakila.payment l 
JOIN sakila.staff r 
ON l.staff_id = r.staff_id;
-- Step 2
SELECT r.staff_id, r.first_name, r.last_name, sum(l.amount) AS "total_amount" FROM sakila.payment l JOIN sakila.staff r ON l.staff_id = r.staff_id
WHERE date_format(l.payment_date, "%Y-%m") = "2005-08"
GROUP BY r.staff_id
ORDER BY sum(l.amount) DESC;


-- 9. List all films and the number of actors who are listed for each film.
-- Step 1
SELECT * FROM sakila.actor x
JOIN sakila.film_actor y
ON x.actor_id = y.actor_id
JOIN sakila.film z
ON y.film_id = z.film_id;
-- Step 2
SELECT y.film_id, z.title, count(x.actor_id) AS "actors_count" FROM sakila.actor x JOIN sakila.film_actor y ON x.actor_id = y.actor_id JOIN sakila.film z ON y.film_id = z.film_id
GROUP BY y.film_id
ORDER BY count(x.actor_id) DESC;


-- 10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer.
SELECT * FROM sakila.payment;               -- Used to check data
SELECT * FROM sakila.customer;               -- Used to check data

-- Step 1
SELECT * FROM sakila.customer l
JOIN sakila.payment r
ON l.customer_id = r.customer_id;
-- Step 2
SELECT l.customer_id, l.first_name, l.last_name, sum(r.amount) AS "customer_total_amount" FROM sakila.customer l JOIN sakila.payment r ON l.customer_id = r.customer_id
GROUP BY l.customer_id
ORDER BY sum(r.amount) DESC;


-- 11. Write a query to display for each store its store ID, city, and country.
-- Step 1
SELECT * FROM sakila.store st
JOIN sakila.address ad
ON st.address_id = ad.address_id
JOIN sakila.city ci
ON ad.city_id = ci.city_id
JOIN sakila.country co
ON ci.country_id = co.country_id;
-- Step 2
SELECT st.store_id, ci.city, co.country FROM sakila.store st
JOIN sakila.address ad
ON st.address_id = ad.address_id
JOIN sakila.city ci
ON ad.city_id = ci.city_id
JOIN sakila.country co
ON ci.country_id = co.country_id;


-- 12. Write a query to display how much business, in dollars, each store brought in.
-- Store + Customer + Payment
SELECT * FROM sakila.store x
JOIN sakila.customer y
ON x.store_id = y.store_id
JOIN sakila.payment z
ON y.customer_id = z.customer_id;
-- Step 2
SELECT x.store_id, sum(z.amount) AS "store_total_amount" FROM sakila.store x JOIN sakila.customer y ON x.store_id = y.store_id JOIN sakila.payment z ON y.customer_id = z.customer_id
GROUP BY x.store_id;


-- 13. What is the average running time of films by category?
SELECT ca.name, format(avg(f.length), 2) AS "avg_running_time" 
FROM sakila.film f 
JOIN sakila.film_category fc ON f.film_id = fc.film_id 
JOIN sakila.category ca ON fc.category_id = ca.category_id
GROUP BY ca.category_id; 


-- 14. Which film categories are longest?
SELECT ca.name, format(avg(f.length), 2) AS "avg_running_time"
FROM sakila.film f 
JOIN sakila.film_category fc ON f.film_id = fc.film_id 
JOIN sakila.category ca ON fc.category_id = ca.category_id
GROUP BY ca.category_id
ORDER BY avg(f.length) DESC;


-- 15. Display the most frequently rented movies in descending order.
SELECT a.title, count(c.rental_id) AS "most_rented" 
FROM sakila.film a 
JOIN sakila.inventory b ON a.film_id = b.film_id 
JOIN sakila.rental c ON b.inventory_id = c.inventory_id
GROUP BY a.title 
ORDER BY count(c.rental_id) DESC;


-- 16. List the top five genres in gross revenue in descending order.
SELECT a.name AS "genre", sum(f.amount) AS "gross_revenue" 
FROM sakila.category a 
JOIN sakila.film_category b ON a.category_id = b.category_id 
JOIN sakila.film c ON b.film_id = c.film_id
JOIN sakila.inventory d ON c.film_id = d.film_id
JOIN sakila.rental e ON d.inventory_id = e.inventory_id
JOIN sakila.payment f ON e.rental_id = f.rental_id
GROUP BY a.name
ORDER BY sum(f.amount) DESC
LIMIT 5;


-- 17. Is "Academy Dinosaur" available for rent from Store 1?
SELECT l.title, r.store_id, count(r.inventory_id) AS "units_available" FROM sakila.film l
JOIN sakila.inventory r
ON l.film_id = r.film_id
WHERE l.title = "Academy Dinosaur" AND r.store_id = 1
GROUP BY r.store_id;

