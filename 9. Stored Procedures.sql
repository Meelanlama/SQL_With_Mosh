-- Store and organize SQL,Faster execution,Data security
-- creating a stored procedure
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
-- BODY
	SELECT * FROM clients;
END $$
DELIMITER ;

-- calling
Call get_clients();

-- exercise
-- create stored procedure called get_invoices_with_balance to return all the invoices with a balance > 0
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
	SELECT * FROM invoices_with_balance
    WHERE balance >  0;
END $$
DELIMITER ;

-- easy if you create procedure using mysql workbench
-- DROP procedure
DROP PROCEDURE IF EXISTS get_clients; 

-- Adding Parameter
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE  get_clients_by_state(state CHAR(2)) -- NY, CA, TX
BEGIN
SELECT * FROM clients c
WHERE c.state = state; -- comparing state with parameter
END $$
DELIMITER ; 

--
CALL get_clients_by_state('CA');

-- exercise
-- write a stored procedure to return invoices for a given client
-- get_invoices_by_client

DROP PROCEDURE IF EXISTS get_invoices_by_client;

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client(client_id INT)
BEGIN
	SELECT * FROM invoices i
	WHERE i.client_id = client_id;
END	$$
DELIMITER ; 

-- DEFAULT VALUE IN PARAMETER
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE  get_clients_by_state(state CHAR(2)) -- NY, CA, TX
BEGIN
	SELECT * FROM clients c
	WHERE c.state = IFNULL(state,c.state);
END $$
DELIMITER ;

CALL get_clients_by_state(NULL);

-- exercise
-- write a stored procedure called get_payments with two parameters
-- To get the client id and payment method they used to pay
-- client_id => INT ,payment_method_id => TINYINT

DROP PROCEDURE IF EXISTS get_payments;

DELIMITER $$
CREATE PROCEDURE get_payments(client_id INT, payment_method TINYINT) 
BEGIN
	SELECT * FROM payments p
    WHERE p.client_id = IFNULL(client_id,p.client_id)
    AND 
    p.payment_method = IFNULL(payment_method,p.payment_method);
END $$
DELIMITER ;

CALL get_payments(1,NULL);

-- Parameter validation
DROP procedure IF EXISTS `make_payment`;

-- Procedure to update the invoice table
DELIMITER $$
USE `sql_invoicing`$$
CREATE PROCEDURE `make_payment` (
	invoice_id INT,
	payment_amount DECIMAL(9,2),
    payment_date DATE
    )
BEGIN
	-- validation
	IF payment_amount <=0 THEN
		SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid amount'; -- code to generate msg for error, like exception in java
	END IF;
    
	UPDATE invoices i
    SET 
		i.payment_total = payment_amount,
        i.payment_date = payment_date
        WHERE i.invoice_id = invoice_id;
END	$$
DELIMITER ;

-- output parameter
-- OUT in parameter means output parameter
DROP procedure IF EXISTS `get_unpaid_invoices_for_client`;

DELIMITER $$
CREATE PROCEDURE `get_unpaid_invoices_for_client` (client_id INT, OUT invoices_count INT, OUT invoices_total DECIMAL(9,2))
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total -- copying the count and sum into output parameter
    FROM invoices i
    WHERE i.client_id = client_id
    AND payment_total = 0;
END$$
DELIMITER ;

-- @ is used to define variable
-- output parameter is not used frequently
set @invoices_count = 0;
set @invoices_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total;

-- variables
-- user or session variables, they are free as program closes 
set @invoices_count = 0;

-- local variable
-- as soon as stored procedure is finished local variable free

DROP procedure IF EXISTS `get_risk_factor`;

DELIMITER $$
USE `sql_invoicing`$$
CREATE PROCEDURE `get_risk_factor` ()
BEGIN
	-- local variables
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
	DECLARE invoices_total DECIMAL(9,2);
	DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count,invoices_total
    FROM invoices;
    
	SET risk_factor = invoices_total/invoices_count * 5;

    SELECT risk_factor;
END$$
DELIMITER ;

-- FUNCTIONS
-- CREATE YOUR OWN FUNCTION
-- RETURN ONLY SINGLE VALUE

USE `sql_invoicing`;
DROP function IF EXISTS `get_risk_factor_for_client`;

DELIMITER $$
USE `sql_invoicing`$$
CREATE FUNCTION `get_risk_factor_for_client` (client_id INT)
RETURNS INTEGER
-- DETERMINISTIC  -- always return same value like tax_amount, returns same output for the same input
READS SQL DATA -- SELECT STATEMENT
-- MODIFIES SQL DATA -- insert update 
BEGIN
	-- local variables
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
	DECLARE invoices_total DECIMAL(9,2);
	DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count,invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;

	SET risk_factor = invoices_total/invoices_count * 5;
    
    RETURN IFNULL(risk_factor, 0);
RETURN 1;
END$$

DELIMITER ;

-- calling function
SELECT client_id,name,get_risk_factor_for_client(client_id) AS risk_factor
FROM clients;

DROP FUNCTION IF EXISTS get_risk_factor_for_client;

-- Other convetions to write
-- getRiskFactor
-- whatever convention is there stick to it.








