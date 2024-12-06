-- how much we sold in each state, summarize data
-- functions
SELECT 
	MAX(invoice_total) AS Maximum,
    MIN(invoice_total) AS Minimum,
    AVG(invoice_total) AS Average,
    SUM(invoice_total) AS Total,
    COUNT(invoice_total) AS Number_of_invoices,
    COUNT(payment_date) AS Number_of_payments,
    COUNT(DISTINCT payment_date) AS Number_of_clients,
    COUNT(*) AS total_records
FROM invoices
WHERE invoice_date > '2019-07-01';

-- exercise
SELECT 
	'First Half of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS 'What Money We Expect'
FROM invoices
WHERE invoice_date 
	BETWEEN '2019-01-01' AND '2019-06-01'
	UNION   
 SELECT 
	'Second Half of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS 'What Money we Expect'
FROM invoices
WHERE invoice_date 
	BETWEEN '2019-07-01' AND '2019-12-31'
	UNION
SELECT 
	'Total of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
	SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS 'What Money we Expect'
FROM invoices
WHERE invoice_date 
	BETWEEN '2019-01-01' AND '2019-12-31';
    
-- GROUP BY CLAUSE
SELECT 
	state,city,
	SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING(client_id)
-- WHERE  invoice_date >= '2019-07-01'
GROUP BY state,city;
-- ORDER BY total_sales DESC;

-- Exercise
SELECT 
date,pm.name AS payment_method,
SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
ON p.payment_method = pm.payment_method_id
GROUP BY pm.name,date
ORDER BY date;

-- HAVING
-- when using column in having  it should be referenced in select 
SELECT 
	client_id,
	SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;

-- Exercise
-- Get the customers located in virginia who have spent more than $100 
SELECT c.customer_id, c.first_name, c.state,
SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
GROUP BY c.customer_id, c.first_name, c.state
HAVING state = 'VA' AND total_sales > 100;

-- ROLLUP used for summarizing
SELECT 
	state,city,
	SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING(client_id)
GROUP BY state,city WITH ROLLUP;

-- exercise
SELECT pm.name AS payment_method,
SUM(amount) AS total
FROM payments p
JOIN payment_methods pm
ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;






    
     
    

    
    

