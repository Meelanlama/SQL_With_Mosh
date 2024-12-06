-- STRING 
-- CHAR(x) fixed-length
-- VARCHAR(x)  max:  64kb
-- standard length,-- VARCHAR(50) FOR short strings,-- VARCHAR(255) FOR medium strings
-- text max : 64 kb
-- MEDIUMTEXT max :16MB
-- LONGTEXT max : 4gb

-- INTEGERS
-- TINYINT: 1b [-128,127]
-- UNSIGNED TINYINT: [0,255] - only store positive value, use for people age
-- SMALL INT
-- INT
-- MEDIUM INT

-- fixed point and floating point
-- Decimal(p,s) => precision(maximum number of digit betn 1-65), scale(number of digits after decimal point)
-- DECIMAL(9,2) = 1234567.89
-- NUMERIC
-- FIXED
-- FLOAT
-- DOUBLE

-- BOOLEAN TYPES
-- BOOL, BOOLEAN
-- UPDATE POSTS SET is_published = TRUE(1) # OR FALSE(0)

-- ENUM AND SET TYPES
-- ALTER TABLE `sql_store`.`products` 
-- ADD COLUMN `size` ENUM('small', 'medium', 'large') NULL AFTER `unit_price`;
-- only value we can add in size is enum values
-- enum is generally not prefferd to use, they are not reusable,should be avoided.
-- look up table should be used like payment_method_1

-- DATE AND TIME
-- DATE, TIME, DATETIME = 8b,TIMESTAMP = 4b(only upto 2038), YEAR

-- BLOBS
-- USED TO STORE large amount of binary data like images,pdf
-- USING blobs increase database size,slowe backup,performance problems,more code to read/write image,
-- generally dont apply
-- TINYBLOB ,BLOB, MEDIUMBLOB,LONGBLOB

-- JSON DOCUMENT
-- lightweight format for storing and transferring over internet
-- used mainly by mobile app
-- {
-- "key":value
-- }

-- standard json format
-- UPDATE products 
-- SET properties = '{
-- 	"dimensions": [7,8,9],
--     "weight": 10,
--     "manufacturer": {"name":"Asus"}
-- }'
-- WHERE product_id = 1;

SELECT *
FROM products;

-- ANOTHER WAY TO CREATE JSON IN SQL

UPDATE products 
SET properties = JSON_OBJECT(
	'weight',10,
    'dimensions', JSON_ARRAY(7,8,9),
    'manufactuerer', JSON_OBJECT('name','Asus')
)
WHERE product_id = 1;

-- EXTRACT INDIVIUDAL KEY VALUE
-- $ for string
-- $.--[] for array

 SELECT product_id, properties -> '$.weight','$.dimensions[0]','$.manufactuerer.name'
 FROM products
 where product_id = 1;

-- ->> for not getting "" in nested object string
SELECT product_id, properties ->> '$.manufactuerer.name'
FROM products
where properties ->> '$.manufactuerer.name' = 'Asus';

-- updating existing weight and adding age in column using json set
UPDATE products 
SET properties = JSON_SET(
	properties,
    '$.weight',20,
    '$.age',22
)
WHERE product_id = 1;

-- Removing from json column using jsonremove
UPDATE products 
SET properties = JSON_REMOVE(
	properties,
    '$.age'
)
WHERE product_id = 1;



