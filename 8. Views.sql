-- View
CREATE VIEW sales_by_client AS
SELECT
c.client_id,c.name,
SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id,name;

-- exercise
-- create a view to see the balance for each client name clients_balance
-- should have client_id,name,balance column

CREATE OR REPLACE VIEW clients_balance AS
SELECT c.client_id,c.name,SUM(i.invoice_total - payment_total) AS balance
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id,name;

-- ALTERING AND DROP VIEW
DROP VIEW clients_balance;

-- UPDATEABLE VIEW
-- IF THE VIEW DONT HAVE
-- DISTINCT
-- AGGREGATE FUNCTION(MIN,MAX,SUM,AVG)
-- GROUP BY/ HAVING
-- UNION

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT * , invoice_total - payment_total AS balance
FROM invoices
WHERE(invoice_total - payment_total) > 0
WITH CHECK OPTION; 
-- this is updatable view

DELETE FROM invoices_with_balance
WHERE invoice_id = 19;

UPDATE invoices_with_balance
SET due_date = date_add(due_date, interval 2 DAY)
WHERE invoice_id = 1;

-- row may be deleted or disappear while updating some rows
-- use with check option while creating view to prevent this
UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3;

-- other benifits of view
-- simplify queries
-- reduce the impact of changes
-- restirct access to the data




