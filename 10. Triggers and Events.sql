-- Trigger is a block of code that automatically gets executed before or after an insert,update or delete statement
-- helps in data consistency

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', Now());
END $$

DELIMITER ;

-- 
INSERT INTO payments
VALUES(DEFAULT,5,3,'2024-11-29',10,1);payments

-- Exercise
-- create a trigger that gets fired when we delete a payment.

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete;

CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount 
    WHERE invoice_id = OLD.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
END $$    
	
DELIMITER ;

-- 
DELETE FROM payments
WHERE payment_id = 11;

-- view triggers
SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'payemnts%';
-- tablename_before or after _ insert or delete , update

-- DROPPING TRIGGERS
DROP TRIGGER IF EXISTS payments_after_insert;

-- Using Triggers , INSERT query is updated in trigger
USE sql_invoicing;

CREATE TABLE payments_audit
(
	client_id 		INT 			NOT NULL, 
    date 			DATE 			NOT NULL,
    amount 			DECIMAL(9, 2) 	NOT NULL,
    action_type 	VARCHAR(50) 	NOT NULL,
    action_date 	DATETIME 		NOT NULL
);

-- FOR INSERT
INSERT INTO payments
VALUES(DEFAULT,5,3,'2024-11-29',10,1);

-- EVENTS
-- A task(or block of SQL code) that gets executed according to a schedule
-- Automate database maintenance

-- SHOW VARIABLES LIKE 'event%';
-- SET GLOBAL event_scheduler = OFF;

DELIMITER $$

CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
	-- AT '2024-11-30'
    EVERY 1 YEAR STARTS '2025-01-01' ENDS '2029-01-01'
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
END $$

DELIMITER ;

-- VIEW,DROP ALTER EVENTS;

SHOW EVENTS;
SHOW EVENTS LIKE 'yearly%';
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;

ALTER EVENT  yearly_delete_stale_audit_rows DISABLE; -- ENABLE





