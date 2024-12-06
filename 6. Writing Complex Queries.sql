-- Find products that are more expensive than lettuce (id=3)
SELECT *
FROM products
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
); 

-- IN SQL_hr database
-- Find employees who earn more than average
SELECT * 
FROM employees
WHERE salary > (
	SELECT 
    AVG(salary)
    FROM employees
);

-- Find the products that have never been ordered products USING IN
SELECT *
FROM products 
WHERE product_id NOT IN (
SELECT DISTINCT product_id
FROM order_items);

-- Exercise Find clients without invoices
SELECT *
FROM clients
WHERE client_id NOT IN( 
SELECT DISTINCT client_id 
FROM invoices);

-- Sub queries vs joins
-- Find clients without invoices
-- USING JOIN
SELECT *
FROM clients
LEFT JOIN invoices USING (client_id)
WHERE invoice_id IS NULL;

-- Find customers who have ordered lettuce(id = 3)
-- select customer_id,first_name,last_name

-- SUBQUERY
SELECT customer_id,first_name,last_name
FROM customers
WHERE customer_id IN(
	SELECT o.customer_id
	FROM order_items oi
    JOIN orders o USING(order_id)
	WHERE product_id = 3
);

-- join
SELECT DISTINCT customer_id,first_name,last_name
FROM customers customers
JOIN orders o USING(customer_id)
JOIN order_items oi  USING(order_id)
WHERE oi.product_id = 3;

-- ALL keyword
--  Find clients invoices larger than invoice of client 3

SELECT *
FROM invoices 
WHERE invoice_total > (
SELECT MAX(invoice_total)
FROM invoices
WHERE client_id = 3);

SELECT *
FROM invoices 
WHERE invoice_total > ALL(
SELECT invoice_total
FROM invoices
WHERE client_id = 3);

-- ANY keyword
-- SELECT Clients with at least two invoices
SELECT *
FROM clients
WHERE client_id = ANY (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) >=2
);

-- SELECT employees whose salary is above the average in their office
-- co related sub query is something that correlation with outer query using alias
SELECT * 
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
);

-- exercise
-- get invoices that are larger than client's average invoice amount
SELECT *
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
	FROM invoices 
	WHERE client_id = i.client_id );
    
-- exists
-- select clients that have an invoice

-- gives large result set and makes slow
SELECT *
FROM clients
WHERE client_id IN(
	SELECT DISTINCT client_id
	FROM invoices);

-- Another, exists makes query faster
SELECT *
FROM clients c
WHERE EXISTS(
	SELECT client_id
	FROM invoices
    WHERE client_id = c.client_id);
    
-- exercise
-- find the products that have never been ordered
SELECT *
FROM products p
WHERE NOT EXISTS(
	SELECT product_id
    FROM order_items oi
    WHERE product_id = p.product_id);
    
-- sub queries in select clause
SELECT invoice_id,invoice_total,
	(SELECT AVG(invoice_total)
	FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS Difference
FROM invoices;

-- exercise
SELECT client_id, name, SUM(invoice_total) AS total_sales,
	(SELECT AVG(invoice_total) FROM invoices) AS average,
    SUM(invoice_total) - (SELECT average) As difference
FROM clients
LEFT JOIN invoices USING(client_id)
GROUP BY client_id;

-- another way
SELECT client_id,name,
	(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
	(SELECT AVG(invoice_total) FROM invoices) AS average,
    (SELECT total_sales - average) As difference
FROM clients c;
    
-- sub query in from clause
SELECT *
FROM (
SELECT client_id,name,
	(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
	(SELECT AVG(invoice_total) FROM invoices) AS average,
    (SELECT total_sales - average) As difference
FROM clients c) AS sales_summmary
WHERE total_sales IS NOT NULL;

-- using sub query in from clause creates complex
-- use view 

    
    
	
    
     

















