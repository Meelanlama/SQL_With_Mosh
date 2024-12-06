SELECT * 
FROM customers
WHERE birth_date > '1990-01-01' OR 
(points > 1000 AND state = 'VA');

-- AND ALways execute first because of percedance

-- GET THE orders placed this year
-- SELECT * 
-- FROM orders
-- WHERE order_date >= '2019-01-01';

-- EXERCISE
SELECT * 
FROM order_items
WHERE order_id = 6 AND unit_price * quantity > '30';

-- IN
SELECT * 
FROM Customers
WHERE state NOT IN ('VA','FL','GA');

-- EXERCISE
-- RETURN PRODUCTS WITH
-- Quantity in stock equal to 49,38,72

SELECT * 
FROM products
WHERE quantity_in_stock IN (49,38,72);

-- BETWEEN OPERATOR

SELECT * 
FROM customers
WHERE points BETWEEN 1000 AND 3000;

-- exercise

SELECT * 
FROM customers
WHERE birth_date between '1990-01-01' AND '2000-01-01';

-- like operator(old)

SELECT * 
FROM customers
WHERE last_name LIKE '%y';
-- % ANY NUMBER OF CHARACTER %a a% %a%
-- ___ single character

-- Exercise

SELECT * 
FROM customers
WHERE phone LIKE '%9';

-- REGEXP OPERATOR (FOR COMPLEX PATETRN)
-- ^ first in the  string
-- $ end of string
-- | Logial OR= bab|ma
-- [] range = [a-f]

SELECT * 
FROM customers
WHERE last_name regexp 'a[b-f]';

-- EXERCISE
-- GET THE CUSTOMER WHOSE
-- first names are elka or ambur
-- last names end with ey or on
-- last name start with my or contains se
-- last names contain b followed by r or u

SELECT * 
FROM customers
-- WHERE first_name regexp 'elka|ambur';
-- WHERE last_name regexp 'ey$|on$';
 -- WHERE last_name regexp '^my|se';
 WHERE last_name regexp 'B[ru]';
 
 
 -- IS NULL
 
 SELECT * 
FROM customers
WHERE phone IS NOT NULL;

-- GET the orders that are not shipped
SELECT * 
FROM orders
WHERE shipped_date IS NULL;

-- ORDER BY
SELECT * 
FROM customers
ORDER BY state DESC, first_name ASC;

-- EXERCISE
SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

-- LIMIT CLAUSE

SELECT *
FROM customers
-- LIMIT 5;
LIMIT 6, 3; 
-- SKIP 6 ROWS AND RETRIEVE 3 ROWS
-- page 1: 1-3
-- page 2: 4-6
-- page 3: 7-9

-- GET THE TOP THREE LOYAL CUSTOMERS

SELECT * 
FROM customers
ORDER BY points DESC
LIMIT 3;







