-- CREATE INDEXES
EXPLAIN SELECT customer_id FROM customers where state = 'CA'; 

SELECT COUNT(*) FROM customers; 

CREATE INDEX indx_state ON customers (state);

-- EXERCISE
-- WRITE A QUERY TO FIND CUSTOMERS WITH MORE THAN 1000 POINTS;

EXPLAIN SELECT customer_id FROM customers where points > 1000;

CREATE INDEX indx_points ON customers (points);

-- VIEW INDEXES
-- for accurate view, run this query first and view index
ANALYZE TABLE customers;

SHOW INDEXES IN customers;

SHOW INDEXES IN orders;

-- indexing string columns, it may consume more space and won't perform well
-- smaller indexes are stored in memory and they makes our query run faster
-- so in string, we'll store first few characters or prefix
CREATE INDEX last_name ON customers (last_name(5));

-- searching for optimal prefix in string column
SELECT 
	COUNT(DISTINCT LEFT(last_name,1)),
	COUNT(DISTINCT LEFT(last_name,5))
FROM customers;

-- FULL_TEXT INDEX(Helpful for search engine)
USE sql_blog;
-- SELECT * FROM posts
-- WHERE title LIKE '%reactredux%' OR body LIKE '%reactredux%';

CREATE FULLTEXT INDEX idx_title_body ON posts(title,body);

-- use builtin function after creating index: MATCH,AGAINST
-- it will match every post that have one or more these keywords and can be in anyorder or seperated.

SELECT * ,MATCH (title,body) AGAINST ('react redux') -- RELEVENACE SCORE(0,1) and sorted by these orders
FROM posts
WHERE MATCH (title,body) AGAINST ('react redux');

-- boolean mode , - for excluding, + for including, "" FOR exact string
SELECT * ,MATCH (title,body) AGAINST ('react redux') 
FROM posts
WHERE MATCH (title,body) AGAINST ('react -redux' IN BOOLEAN MODE);

-- COMPOSITE INDEXES(two columns indexing)
-- creating composite index is better than creating indexes for each row
SHOW INDEXES IN customers;

CREATE INDEX idx_state_points ON customers (state,points);

DROP INDEX indx_state ON customers;
DROP INDEX indx_points ON customers;

EXPLAIN SELECT customer_id FROM customers
WHERE state = 'CA' AND points > 1000;

-- ORDER OF COLUMNS IN COMPOSITE INDEXES
-- 1. Put the most frequently used columns first
-- 2. Put the columns with a higher cardinality first (cardinality is number of unique values in index)
-- 3. Try to understand how mysql will execute your query

EXPLAIN SELECT customer_id 
FROM customers
-- force mysql to use index
USE INDEX(indx_lastname_state) 
WHERE state = 'CA' AND last_name LIKE 'A%';

SELECT
	COUNT(DISTINCT state),
    COUNT(DISTINCT last_name)
FROM customers;
 
-- here in this index, it will search all the customer lastname that starts with 'A' regardless of their state and then it'll search state of that customers.
CREATE INDEX indx_lastname_state ON customers (last_name,state);

-- opposite order, as it will search customers in state and their lastname
CREATE INDEX indx_state_lastname ON customers (state,last_name);

-- when should we ignore indexes
-- first query without union scans all rows so,divide into two smaller query and use union

-- create index for points less points scan
CREATE INDEX indx_points ON customers(points);

EXPLAIN SELECT customer_id 
FROM customers
WHERE state = 'CA' 
UNION 
SELECT customer_id  FROM customers
WHERE points > 1000;

-- USING INDEXES FOR SORTING
SHOW INDEXES IN customers;

-- sorting by column which don't have index, they use filsort and it's very heavy
EXPLAIN SELECT customer_id FROM customers ORDER BY first_name;

-- it using backward indexscan as both index are in desc, if it's asc then uses file sort and cost is mych higher for asc
EXPLAIN SELECT customer_id FROM customers 
ORDER BY state DESC, points DESC;
SHOW status LIKE 'last_query_cost';

-- INDEX MAINTENANACE
-- Watch for duplicate indexes and redundant indexes
-- mysql can create duplicate index without error so watch before creating

