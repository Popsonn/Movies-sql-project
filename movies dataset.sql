-- List down the managers’ names at each store with the full address of each property (street, district, city, country)
SELECT s.staff_id,s.first_name,s.last_name,a.address,a.district,ci.city,co.country FROM movies.staff s
LEFT JOIN movies.address a ON s.address_id = a.address_id
LEFT JOIN movies.city ci ON a.city_id = ci.city_id
LEFT JOIN movies.country co ON ci.country_id = co.country_id

-- Provide list of each inventory item, including store_id, inventory_id, title, film’s rating, rental rate, and replacement cost
SELECT i.inventory_id,s.store_id,f.title,f.rating,f.rental_rate,f.replacement_cost FROM movies.inventory i
JOIN movies.store s ON i.store_id = s.store_id
JOIN movies.film f ON i.film_id = f.film_id

--Provide summary level overview of your inventory — how many inventory items you have with each rating at each store?
WITH sub1 as
(SELECT i.inventory_id,s.store_id,f.title,f.rating,f.rental_rate,f.replacement_cost FROM movies.inventory i
JOIN movies.store s ON i.store_id = s.store_id
JOIN movies.film f ON i.film_id = f.film_id
)

SELECT count(inventory_id),rating,store_id FROM sub1
GROUP BY 2,3
ORDER BY 1

--Extract a table containing the number of films, average replacement cost, and total replacement cost — sliced by store and film category.
SELECT s.store_id,fc.category_id,count(f.film_id),avg(replacement_cost),sum(replacement_cost) from movies.store s
join movies.inventory i on s.store_id = i.store_id
join movies.film f on i.film_id = f.film_id
join movies.film_category fc on f.film_id = fc.film_id
group by 1,2

-- List of all customer names, which store they go to, active or inactive, full address (street address, city, and country)
SELECT CONCAT(c.first_name,' ',c.last_name)as customer_name,c.active,c.store_id,CONCAT(a.address,' ',ci.city,' ',co.country)AS full_address FROM movies.store s
JOIN movies.customer c ON s.store_id = c.store_id
JOIN movies.address a ON c.address_id = a.address_id
JOIN movies.city ci ON a.city_id = ci.city_id
JOIN movies.country co ON ci.country_id = co.country_id

--List of customer names, total lifetime rentals, sum of all payments collected — order on the total lifetime value, most valuable customers on top
SELECT concat(c.first_name,' ',c.last_name),count(r.rental_id)as total_rentals,sum(p.amount)as total_payment from movies.customer c
JOIN movies.rental r ON c.customer_id = r.customer_id
JOIN movies.payment p ON r.rental_id = p.rental_id
GROUP BY 1
ORDER BY 2 desc

-- List of advisor and investor names in one table. Indicate whether they are an investor or an advisor. If they are an investor, include the company they work with.
CREATE TABLE combined_table (
  full_name text,
  investor_or_advisor text,
  company_name text
);

INSERT INTO combined_table (full_name,investor_or_advisor,company_name)
SELECT concat(a.first_name, ' ', a.last_name),'Advisor', NULL FROM movies.advisor a;

INSERT INTO combined_table (full_name,investor_or_advisor,company_name)
SELECT concat(i.first_name, ' ', i.last_name),'Investor',i.company_name FROM movies.investor i;

SELECT * FROM combined_table

-- List of advisor and investor names in one table. Indicate whether they are an investor or an advisor. If they are an investor, include the company they work with.
SELECT concat(a.first_name, ' ', a.last_name)as name,
'Advisor' as role,
NULL as company_name
FROM movies.advisor a 
UNION ALL
SELECT concat(i.first_name, ' ', i.last_name)as name,
'Investor' as role,
i.company_name as company_role
FROM movies.investor i

--
with sub1 as(select concat(aa.first_name,' ',aa.last_name)as actor_name,aa.awards,aa.actor_id,
case 
 when aa.awards = 'Emmy,Oscar,Tony' then '3'
  WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Oscar%' THEN '2'
    WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Tony%' THEN '2'
    WHEN aa.awards LIKE '%Oscar%' AND aa.awards LIKE '%Tony%' THEN '2'
 else '1' 
END AS number_of_awards
from movies.actor_award aa),

--select count(actor_name) from sub1
--where number_of_awards = '3'

sub2 AS(
select concat(aa.first_name,' ',aa.last_name)as actor_name,fa.film_id,aa.awards,aa.actor_id,
case 
 when aa.awards = 'Emmy,Oscar,Tony' then '3'
  WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Oscar%' THEN '2'
    WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Tony%' THEN '2'
    WHEN aa.awards LIKE '%Oscar%' AND aa.awards LIKE '%Tony%' THEN '2'
 else '1' 
END AS number_of_awards
from movies.actor_award aa
JOIN movies.film_actor fa on aa.actor_id = fa.actor_id)

--select count(distinct actor_name) from sub2
--where number_of_awards = '3'
SELECT (COUNT(DISTINCT sub2.actor_name)::numeric / COUNT(sub1.actor_name)::numeric) * 100 AS percentage
FROM sub1
JOIN sub2 ON sub1.actor_id = sub2.actor_id
WHERE sub1.number_of_awards = '3';

--
with sub1 as(select concat(aa.first_name,' ',aa.last_name)as actor_name,aa.awards,aa.actor_id,
case 
 when aa.awards = 'Emmy,Oscar,Tony' then '3'
  WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Oscar%' THEN '2'
    WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Tony%' THEN '2'
    WHEN aa.awards LIKE '%Oscar%' AND aa.awards LIKE '%Tony%' THEN '2'
 else '1' 
END AS number_of_awards
from movies.actor_award aa),

--select count(actor_name) from sub1
--where number_of_awards = '3'

sub2 AS(
select concat(aa.first_name,' ',aa.last_name)as actor_name,fa.film_id,aa.awards,aa.actor_id,
case 
 when aa.awards = 'Emmy,Oscar,Tony' then '3'
  WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Oscar%' THEN '2'
    WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Tony%' THEN '2'
    WHEN aa.awards LIKE '%Oscar%' AND aa.awards LIKE '%Tony%' THEN '2'
 else '1' 
END AS number_of_awards
from movies.actor_award aa
JOIN movies.film_actor fa on aa.actor_id = fa.actor_id)

--select count(distinct actor_name) from sub2
--where number_of_awards = '3'
SELECT (COUNT(DISTINCT sub2.actor_name)::numeric / COUNT(sub1.actor_name)::numeric) * 100 AS percentage
FROM sub1
JOIN sub2 ON sub1.actor_id = sub2.actor_id
WHERE sub1.number_of_awards = '2';
 
--
with sub1 as(select concat(aa.first_name,' ',aa.last_name)as actor_name,aa.awards,aa.actor_id,
case 
 when aa.awards = 'Emmy,Oscar,Tony' then '3'
  WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Oscar%' THEN '2'
    WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Tony%' THEN '2'
    WHEN aa.awards LIKE '%Oscar%' AND aa.awards LIKE '%Tony%' THEN '2'
 else '1' 
END AS number_of_awards
from movies.actor_award aa),

--select count(actor_name) from sub1
--where number_of_awards = '3'

sub2 AS(
select concat(aa.first_name,' ',aa.last_name)as actor_name,fa.film_id,aa.awards,aa.actor_id,
case 
 when aa.awards = 'Emmy,Oscar,Tony' then '3'
  WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Oscar%' THEN '2'
    WHEN aa.awards LIKE '%Emmy%' AND aa.awards LIKE '%Tony%' THEN '2'
    WHEN aa.awards LIKE '%Oscar%' AND aa.awards LIKE '%Tony%' THEN '2'
 else '1' 
END AS number_of_awards
from movies.actor_award aa
JOIN movies.film_actor fa on aa.actor_id = fa.actor_id)

--select count(distinct actor_name) from sub2
--where number_of_awards = '3'
SELECT (COUNT(DISTINCT sub2.actor_name)::numeric / COUNT(sub1.actor_name)::numeric) * 100 AS percentage
FROM sub1
JOIN sub2 ON sub1.actor_id = sub2.actor_id
WHERE sub1.number_of_awards = '1';














