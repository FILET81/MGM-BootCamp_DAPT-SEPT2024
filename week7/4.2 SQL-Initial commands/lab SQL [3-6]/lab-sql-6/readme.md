![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | SQL Queries 8

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

### Instructions

1. Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
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
