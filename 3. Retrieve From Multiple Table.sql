SELECT o.customer_id,first_name,last_name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
    
-- Join order_items and products
SELECT p.product_id, p.name, o.quantity, o.unit_price, o.quantity * o.unit_price AS 'Total Price'
From products p
JOIN order_items o
ON p.product_id = o.product_id;

-- Joining across the other databases
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
ON oi.product_id = p.product_id;

-- SELF JOIN
SELECT e.employee_id,e.first_name, m.first_name AS 'Manager'
FROM employees e
JOIN employees m
ON e.reports_to = m.employee_id;

-- JOIN MORE THAN 2 TABLES
SELECT 
	o.order_id,o.order_date,
    c.first_name,c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id;
    
-- Exercise
SELECT 
	p.invoice_id,p.date,p.amount,
    c.name,
    pm.name
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
 JOIN clients c
	ON p.client_id = c.client_id;
    
-- Compound Join condition
SELECT * 
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_Id
    AND oi.product_id = oin.product_id;
    
-- Implicit Join syntax (Not recommended to use)
SELECT *
FROM customers c,orders o
WHERE c.customer_id = o.order_id;

-- OUTER LEFT JOIN
SELECT c.customer_id,c.first_name,o.order_id
FROM customers c
LEFT JOIN orders o 
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- OUTER RIGHT JOIN
SELECT c.customer_id,c.first_name,o.order_id
FROM orders o
RIGHT JOIN  customers c
ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Exercise
SELECT  p.product_id,p.name,o.quantity
FROM products p 
LEFT JOIN order_items o
ON o.product_id = p.product_id;

-- OUTER JOIN WITH 3 TABLES
-- AVOID USING LEFT AND RIGHT JOIN IN ONE QUERY
-- USE LEFT JOIN
SELECT
	c.customer_id,c.first_name,c.address,c.city,
    o.order_id,o.shipped_date,
    s.name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN shippers s
ON o.shipper_id = s.shipper_id;


-- EXERCISE
SELECT
	o.order_id,c.first_name AS customer,o.order_date,
	s.name AS Shipper,
	os.name AS status
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
JOIN order_statuses os
ON o.status = os.order_status_id
LEFT JOIN shippers s
ON o.shipper_id = s.shipper_id;

-- Self outer join
SELECT e.employee_id,e.first_name, m.first_name AS 'Manager'
FROM employees e
Left JOIN employees m
ON e.reports_to = m.employee_id;

-- USING CLAUSE
-- if column name is same 

SELECT 
	c.customer_id,first_name,
	o.order_id,
    s.name AS Shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id;
    USING(customer_id)
LEFT JOIN shippers s
	USING(shipper_id);
    

SELECT *
FROM order_items oi
JOIN order_item_notes oin
USING (order_id,product_id);
    
-- Exercise
SELECT p.date,c.name,p.amount,pm.name
FROM payments p
JOIN clients c
USING (client_id)
JOIN payment_methods pm
ON p.payment_method = pm.payment_method_id;

-- CROSS JOIN
SELECT  c.first_name AS customer, p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY customer;

-- Exercise cross join between shippers and products 
-- USING IMPLICIT SYNTAX
-- USING EXPLICIT SYNTAX

SELECT s.name AS shipper,p.name As product
FROM shippers s,products p
ORDER BY shipper;

SELECT s.name AS shipper,p.name As product
FROM shippers s
CROSS JOIN products p
ORDER BY shipper;


		



	

    


    



