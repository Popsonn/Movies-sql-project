-- List down the managers’ names at each store with the full address of each property (street, district, city, country)
SELECT s.staff_id,s.first_name,s.last_name,a.address,a.district,ci.city,co.country FROM movies.staff s
LEFT JOIN movies.address a ON s.address_id = a.address_id
LEFT JOIN movies.city ci ON a.city_id = ci.city_id
LEFT JOIN movies.country co ON ci.country_id = co.country_id