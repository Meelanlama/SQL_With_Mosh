INSERT INTO customers(first_name,last_name,birth_date,address,city,state)
VALUES('John','Smith', '1990-01-01','Kathmandu','Gokarna','CA');

-- insert multiple rows
INSERT INTO shippers(name)
VALUES	('Shipper 1'),
		('Shipper 2'),	
		('Shipper 3');
        
-- Insert 3 rows in product tables
INSERT INTO products (name,quantity_in_stock,unit_price)
VALUES	('Product 1', 1, 10),
		('Product 2', 2, 20),
        ('Product 2', 3, 30);
        
-- Inserting hierarchical rows(parent,child)
INSERT INTO orders(customer_id,order_date,status)
VALUES 	(1,'2024-11-26',1);

INSERT INTO order_items
VALUES(last_insert_id(),1,1,2.50),
	(last_insert_id(),2,1,3.50);

-- BUILT IN FUNCTION to check last id inserted
SELECT last_insert_id();

-- COPY Data from one table to another
CREATE TABLE orders_archives AS
-- SUB QUERY 
SELECT * FROM orders;

-- INSERT INTO TABLE
INSERT INTO orders_archives
-- SUBQUERY to insert
SELECT * FROM orders
WHERE order_date < '2019-01-01';

-- EXERCISE
CREATE TABLE invoices_archive AS
-- SUB QUERY 
SELECT i.invoice_id,number,c.name,i.invoice_total,payment_total,invoice_date,due_date,payment_date
FROM invoices i
JOIN clients c
ON i.client_id = c.client_id
WHERE payment_date IS NOT NULL;

-- UPDATE SINGLE ROW
UPDATE invoices
SET payment_total = 10, payment_date = '2024-11-26'
WHERE invoice_id = 1;

UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE invoice_id = 3;

-- UPDATE MULTIPLE ROW
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN (3,4);

-- EXERCISE
-- Write a sql statement to
-- give any customers born before 1990 50 extra points
UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- USING Sub query in update where we dont know client id 
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id = 	-- IN
	(SELECT client_id
	FROM clients
	WHERE name = 'Myworks');
    -- WHERE state IN ('CA','NY');
    
-- EXERCISE    

UPDATE orders
SET comments = 'Gold customer' 
WHERE comments IS NULL
AND customer_id IN 
		(SELECT customer_id
		FROM customers
		where points > 3000);

-- DELETE
DELETE FROM invoices
WHERE client_id = (	-- invoice_id = 1;
SELECT client_id
FROM clients
WHERE name = 'Myworks'
);

-- RESTORE Database
-- using sql file








