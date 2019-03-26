Use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name
from actor a;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(UPPER(first_name), " ", UPPER(last_name)) AS 'Actor Name'
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT * FROM actor WHERE first_name like 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name like '%GEN%' ;

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name like '%LI%'
Order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country c
WHERE (c.country) IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD Description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP Description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select distinct last_name, count(last_name) as CountOf from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select distinct last_name, count(last_name) as CountOf 
from actor group by last_name
HAVING 
    COUNT(*) > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT * FROM actor WHERE last_name like 'Williams' ;
update actor set first_name='HARPO' where actor_id = 172;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name='GROUCHO' where actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address

-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name, a.*
from staff s
inner join address a on a.address_id = s.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select (concat(UPPER(first_name), " ", UPPER(last_name)) AS staff_name from staff s), SUM(amount) from payment p

select s.first_name, s.last_name, p.amount
from payment p
	inner join staff s on s.staff_id = p.staff_id
group by s.first_name, s.last_name;

Error Code: 1055. Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'sakila.p.amount' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by


select amount 
from payment p
Where payment_date between 2005-08-1 and 2005-8-31

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select count(fa.actor_id), f.title
from film_actor fa
	inner join film f on fa.film_id = f.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select count(f.title)
from film f
inner join inventory i on i.film_id = f.film_id
where title = "Hunchback Impossible"

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(p.amount)
from customer c
	join payment p on p.customer_id = c.customer_id
group by c.first_name, c.last_name 
order by c.last_name ASC;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title 
	from film f
		join language l on l.language_id = f.language_id
where name = 'English' AND title like 'k%' or title like 'q%'

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name
from film_actor fa
	inner join film f on fa.film_id = f.film_id 
    inner join actor a on a.actor_id = fa.actor_id
where f.title = 'Alone Trip'

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select cu.first_name, cu.last_name, cu.email
from customer cu
inner join address a on cu.address_id = a.address_id
inner join city ci on a.city_id = ci.city_id
inner join country c on c.country_id = ci.country_id
where country = 'Canada'

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- 7e. Display the most frequently rented movies in descending order.

-- 7f. Write a query to display how much business, in dollars, each store brought in.

-- 7g. Write a query to display for each store its store ID, city, and country.

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view vw_alone_trip_actors as
select a.first_name, a.last_name, f.title
from film_actor fa
	inner join film f on fa.film_id = f.film_id -- 5462
    inner join actor a on a.actor_id = fa.actor_id
where f.title = 'Alone Trip';
-- 8b. How would you display the view that you created in 8a?

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view vw_alone_trip_actors