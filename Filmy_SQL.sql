## Homework Assignment

USE SAKILA;
##* 1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`. 

select first_name AS 'FIRST NAME',
		last_name AS 'LAST NAME' 
from actor;

##1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

select concat(first_name, ' ', last_name) as 'Actor Name'
from actor;

## 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name 
from actor
where first_name = 'Joe';

select actor_id, first_name, last_name 
from actor
where first_name in ('Ed', 'Nick');

##2b. Find all actors whose last name contain the letters `GEN`:

select concat(first_name, ' ', last_name) as 'Actor Name'
from actor
where last_name LIKE '%GEN%';

##2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

select concat(last_name, ', ', first_name) as 'Actor Name'
from actor
where last_name LIKE '%LI%'
ORDER BY last_name ASC;

##2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

##3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.

alter table actor
add middle_name varchar(45)
after first_name;

## 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

alter table actor
change middle_name middle_name blob;

## 3c. Now delete the `middle_name` column.

alter table actor drop middle_name;

## 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*) as number_count
from actor 
group by last_name
order by number_count Desc;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select b.last_name, b.number_count from 
(select last_name, count(*) as number_count
from actor as a 
group by last_name) as b
where b.number_count > 1
order by number_count Desc;

##4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

select first_name, last_name, count(*) as number_count
from actor 
where first_name = 'GROUCHO' AND last_name='WILLIAMS';

select first_name, last_name, count(*) as number_count
from actor 
where first_name = 'HARPO';

select first_name, last_name, count(*) as number_count
from actor 
where last_name='Williams';

## Did not find GROUCHO williams, and the only williams is a Sean WIlliams. 
## Made a query based off of replacing Sean Williams.
Update actor 
set first_name = 'GROUCHO', last_name = 'WILLIAMS'
where first_name = 'SEAN' and
		last_name = 'WILLIAMS';


select * from actor where first_name = 'Groucho' and last_name='Williams';
select * from actor where first_name = 'Harpo' and last_name='Williams';

Update actor 
set first_name = 'Harpo', last_name = 'WILLIAMS'
where first_name = 'Groucho' and
		last_name = 'WILLIAMS';

##4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

update actor
set first_name = 'GROUCHO'
where first_name = 'Harpo' and last_name='Williams' 
order by actor_id 
limit 1;

update actor
set first_name = 'MUCHO GROUCHO'
where first_name = 'Harpo' and last_name='Williams' ;

##5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address';

##6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:


select staff.first_name, staff.last_name, address.address, address.address2
from staff
inner join address on staff.address_id = address.address_id;

##6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

select s.first_name, s.last_name, sum(p.amount)
from staff s
inner join payment p
on s.staff_id = p.staff_id
where p.payment_date LIKE '2005-08-%'
group by s.staff_id;

##6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select f.title, count(a.actor_id) as 'Number of Actors'
from film as f
inner join film_actor a
on f.film_id = a.film_id
group by f.title;

##6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select count(f.title) as 'Hunchback Impossible copies'
from film as f
inner join inventory i
on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';
        
##6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

select c.last_name as 'Last Name', c.first_name as 'First Name', sum(p.amount) as 'Total Paid'
from customer c
inner join payment p
on c.customer_id = p.customer_id
group by c.last_name 
ORDER BY c.last_name ASC, c.first_name ASC;

##7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

select sub.title
from
	(select title, language_id
	from film
	where (title like 'K%') or (title like 'Q%')) sub
where sub.language_id = (select language_id 
						from language
						where name = 'English');
        
##7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select actor.first_name as 'First Name', actor.last_name as 'Last Name'
	from actor
	where actor.actor_id IN
		(select film_actor.actor_id
			from film_actor
			where film_id = 
				(select film_id 
					from film 
					where title = 'Alone Trip')) ;
                    
##7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.



select first_name as 'First Name', last_name as 'Last Name', email, country as 'Country'
	from customer cus
    join address a
    on (cus.address_id = a.address_id)
    join city
    on (city.city_id = a.city_id)
    join country c
    on (c.country_id = city.country_id)
	where c.country = 'canada'; 

##7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

select  title as 'Movie Name', name as 'Category'
	from film
    join film_category
    on (film.film_id = film_category.film_id)
    join category
    on (category.category_id = film_category.category_id)
    where name = 'Family';
    
##7e. Display the most frequently rented movies in descending order.

select title as 'Movie', count(rental.rental_date) as 'Rental Frequency'
	from film
    join inventory
    on (film.film_id= inventory.film_id)
    join rental
    on (rental.inventory_id = inventory.inventory_id)
    group by film.title order by count(rental.rental_date) DESC;
    
##7f. Write a query to display how much business, in dollars, each store brought in.

select address.address as 'Store Location', concat('$ ', format(sum(payment.amount), 2)) as 'Total Business in ($)'
	from address
	join staff
	on address.address_id = staff.address_id
    join payment
    on staff.staff_id = payment.staff_id
    group by address;
    

##7g. Write a query to display for each store its store ID, city, and country.

select store_id, address, city, country
	from country
    join city
    on city.country_id = country.country_id
    join address
    on address.city_id = city.city_id
    join store
    on store.address_id = address.address_id;
    
##7h. List the top five genres in gross revenue in descending order. 
##(**Hint**: you may need to use the following tables: 
##category, film_category, inventory, payment, and rental.)

select name as 'Genre', sum(amount) as 'Gross Revenue'
	from category
    join film_category
    on category.category_id = film_category.category_id
    join inventory
    on film_category.film_id = inventory.film_id
    join rental on 
    inventory.inventory_id = rental.inventory_id
    join payment
    on rental.rental_id = payment.rental_id
    group by category.name order by sum(payment.amount) DESC limit 5;
  	
##8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
##Use the solution from the problem above to create a view. 

Create View TopFiveGenres
AS 
select name as 'Genre', sum(amount) as 'Gross Revenue'
	from category
    join film_category
    on category.category_id = film_category.category_id
    join inventory
    on film_category.film_id = inventory.film_id
    join rental on 
    inventory.inventory_id = rental.inventory_id
    join payment
    on rental.rental_id = payment.rental_id
    group by category.name order by sum(payment.amount) DESC limit 5;

##8b. How would you display the view that you created in 8a?
    
select * from topfivegenres;

##8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

drop view topfivegenres;


        
/*** =lang.language_id 
in


* 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
  	
* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

* 3c. Now delete the `middle_name` column.

* 4a. List the last names of actors, as well as how many actors have that last name.
  	
* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
  	
* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
  	
* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
  	
* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
  	
* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

  ```
  	![Total amount paid](Images/total_payment.png)
  ```

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
   
* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

* 7e. Display the most frequently rented movies in descending order.
  	
* 7f. Write a query to display how much business, in dollars, each store brought in.

* 7g. Write a query to display for each store its store ID, city, and country.
  	
* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
  	
* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
  	
* 8b. How would you display the view that you created in 8a?

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

### Appendix: List of Tables in the Sakila DB

* A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

```sql
	'actor'
	'actor_info'
	'address'
	'category'
	'city'
	'country'
	'customer'
	'customer_list'
	'film'
	'film_actor'
	'film_category'
	'film_list'
	'film_text'
	'inventory'
	'language'
	'nicer_but_slower_film_list'
	'payment'
	'rental'
	'sales_by_film_category'
	'sales_by_store'
	'staff'
	'staff_list'
	'store'
```
***/