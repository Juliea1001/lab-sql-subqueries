#Lab | SQL Subqueries

#In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

#Instructions

#1.How many copies of the film Hunchback Impossible exist in the inventory system?
select * from sakila.inventory;
select * from sakila.film;
select count(inventory_id) from sakila.inventory
where film_id= (select film_id from sakila.film
where title='Hunchback Impossible');

#2.List all films whose length is longer than the average of all the films.
select * from sakila.film;
select film_id, title, length from sakila.film 
where length > (select avg(length) from sakila.film);


#3.Use subqueries to display all actors who appear in the film Alone Trip.
select * from sakila.film_actor;
select * from sakila.actor;
select * from sakila.film;

select first_name, last_name, actor_id from sakila.actor join
(select actor_id from sakila.film_actor
where film_id =
(select film_id from sakila.film
where title = 'Alone Trip')) sub using(actor_id);


#4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
select * from sakila.film;
select * from sakila.category;
select * from sakila.film_category;

select sub.film_id, title from sakila.film join
(select film_id from sakila.film_category
where category_id =
(select category_id from sakila.category
where name ='Family')) sub using(film_id);


#5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
#you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select * from sakila.customer;
select * from sakila.country;
select * from sakila.address;
select * from sakila.city;

select first_name, last_name, email from sakila.customer
where address_id in
(select address_id from sakila.address 
where city_id in
(select city_id from sakila.city 
where country_id=
(select country_id from sakila.country
where country ='Canada'))
);

# with joins:

select first_name, last_name, email from sakila.customer cu join
sakila.address a using(address_id) join
sakila.city ci using(city_id) join
sakila.country co using(country_id) 
where country='Canada';


#6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select * from sakila.film;
select * from sakila.film_actor;


select film_id, title from sakila.film
where film_id in 
(select film_id from sakila.film_actor
where actor_id =(select actor_id from (select count(film_id), actor_id from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1) sub1)) ;

#7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie 
#the customer that has made the largest sum of payments#
select * from sakila.payment;
select * from sakila.customer;
select customer_id , sum(amount) over (partition by customer_id) from sakila.payment;

select customer_id, first_name, last_name from sakila.customer 
where customer_id=
(select customer_id from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1);

#8.Customers who spent more than the average payments.
Select customer_id , first_name, last_name from sakila.customer where customer_id in
(Select customer_id from (select distinct customer_id, sum(amount) over (partition by customer_id) as Payments from sakila.payment) sub
where Payments > (select avg(Payments) from (select distinct customer_id, sum(amount) over (partition by customer_id) as Payments 
from sakila.payment) sub)  );