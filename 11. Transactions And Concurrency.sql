-- A group of statement that represents a single unit of work is transaction

START TRANSACTION;

INSERT INTO orders(customer_id,order_date,status)
VALUES (1, '2019-01-01',1);

INSERT INTO order_items
VALUES(last_insert_id(), 1,1,1);

COMMIT;
-- ROLLBACK;

SHOW VARIABLES LIKE 'autocommit';

-- concurrency and locking
-- two or more user trying to access same data, while one user is modifying database and other is accessing
-- use two local instance in mysql and run same code using transaction
-- default behaviour: if a transaction tries to modify it puts lock on that rows until it's done. either commited or rollback

START TRANSACTION;

UPDATE customers
SET points = points + 10
WHERE customer_id = 1;

COMMIT;

-- Concurrency Problem
-- 1. LOST updates: when two tries to update the same data at same time -- use locks but mysql uses it by default
-- 2. Dirty Reads: --use isolation, -- read commited
-- 3. Non Repeating: Read --incosistent read, use up to date data or isolation level(repeatable read)
-- 4. Phantom Reads: -- data appears suddenly like a ghost as other updates it and our query misses it, -- no other transaction should be running, -- use SERIALIZABLE

-- Transaction Isoltaion Levels
-- Level 1. Read Uncomitted: no prevention
-- Level 2. Read Committed: Prevents dirty read
-- Level 3. Repeatable Read: Prevents lostupdate, dirtyreads, non-repeating reads 
-- Level 4. Serializable: Prevents all problem

-- Lower isoltaion level have more concurrency problem but speed would be faster
-- Higher isoltaion level have lower concurrency problem but speed would be slower but more protection
-- In mysql default concurrency is Level 3. Repeatable Read

SHOW VARIABLES LIKE 'transaction_isolation';
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Read Uncomitted Isolation Level

USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT points 
FROM customers
WHERE customer_id = 1; -- here customer points should be 2293 but when update query updates it to 20 without committing and it changes value

-- This code was run in another local instance

-- USE sql_store;
-- START TRANSACTION;
-- UPDATE customers
-- SET points = 20
-- WHERE customer_id = 1;
-- COMMIT;
-- ROLLBACK;

--  Read Comitted Isolation Level

USE sql_store;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT points FROM customers WHERE customer_id = 1; -- here at first after updating showing previous value 
SELECT points FROM customers WHERE customer_id = 1; -- when data is commited, it shows another value in same query, data is not repeated same here
COMMIT;

-- Repeatable Read Isolation Level
USE sql_store;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- default isolation
START TRANSACTION;
SELECT points FROM customers WHERE customer_id = 1;
SELECT points FROM customers WHERE customer_id = 1; -- gives exact same data as above, doesnot change if another client updates database from another
COMMIT;

-- SERIALIZABLE Isolation Level
USE sql_store;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
START TRANSACTION;
SELECT * FROM customers WHERE state = 'VA'; -- SOLVES all concurrency problems, transactions are executed sequentially
COMMIT;

-- This code was run in another local instance

USE sql_store;

START TRANSACTION;
UPDATE customers
SET state  = 'VA'
WHERE customer_id = 3; -- 1, --2
COMMIT;
-- ROLLBACK;

-- DEADLOCKS
-- It happens when different transaction cannot complete. Each transaction hold a lock and keep waiting and never release their lock
USE sql_store;
START TRANSACTION;
UPDATE customers SET state  = 'VA' WHERE customer_id = 1; -- Put a lock on this record so other transaction cannot update it, have to wait 
UPDATE orders SET status = 1 WHERE order_id = 1; -- when this code tries to run its already lock by the second user and have to wait for it to complete
COMMIT;

-- This code was run in another local instance: 2
USE sql_store;
START TRANSACTION;
UPDATE orders SET status = 1 WHERE order_id = 1; -- Put a lock on this record so other transaction cannot update it, have to wait 
UPDATE customers SET state  = 'VA' WHERE customer_id = 1; -- when this code tries to run its already lock by the first user and have to wait for it to complete
COMMIT;

-- They both will be waiting for eachother and never be complete, its called deadlock
-- to reduce deadlock follow the same order when updating multiple records
-- keep transcation small

