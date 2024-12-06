-- NUMERIC FUNCTIONS
SELECT ROUND(7.779,2);
SELECT TRUNCATE(7.779,2);
SELECT CEILING(7.5);
SELECT FLOOR(7.5);
SELECT ABS(7.5);
SELECT RAND();

-- STRING FUNCTIONS
SELECT LENGTH('Milan');
SELECT UPPER('Milan');
SELECT LOWER('MILAN');
SELECT TRIM(' MILAN ');
SELECT LEFT('Milan',3);
SELECT RIGHT('Milan',3);
SELECT SUBSTRING('Milan',2);
SELECT LOCATE('i','Milan');
SELECT REPLACE('Milan','i','ee');
SELECT CONCAT('Milan','Tamang');

SELECT CONCAT(first_name,' ',last_name) AS full_name FROM
customers;

-- DATE functions
SELECT NOW(), curdate(),curtime();
SELECT year(now());
SELECT dayname(now());
SELECT extract(day from now());

-- exercise
SELECT *
FROM orders
where year(order_date) <= year(now());

-- formatting date and time
SELECT DATE_FORMAT(NOW(), '%M,%d,%Y');
SELECT TIME_FORMAT(NOW(), '%H:%i %p');

-- calculating dates and times
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); -- RETURN tommorow day
SELECT DATE_ADD(NOW(), INTERVAL -1 DAY); -- RETURN yesterday day
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR); -- RETURN 1 year 
SELECT DATEDIFF('2019-01-01', '2024-11-28'); -- difference date

-- IF NULL AND COALESCE
SELECT order_id, 
	-- IFNULL(shipper_id, 'Not Assigned') AS shippper
	coalesce(shipper_id,comments, 'Not Assigned') AS shippper
FROM orders;

-- exercise
SELECT CONCAT(first_name,' ',last_name) AS customer,
	IFNULL(phone, 'Unknown') AS phone
FROM customers;

-- if function
-- can be simple without using UNION 
SELECT
	order_id,order_date,
    IF(year(order_date) = year(now()),'Active', 'archived') AS category
    FROM orders;

-- exercise
SELECT product_id,name, COUNT(*) AS orders,
    IF(count(*) > 1,'Many times', 'once') AS frequency
FROM products p
JOIN order_items oi USING (product_id)
GROUP BY product_id,name;

-- case function
SELECT
	order_id,order_date,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW()) THEN 'ACTIVE'
		WHEN YEAR(order_date) = YEAR(NOW()) -1  THEN 'LAST YEAR'
		WHEN YEAR(order_date) < YEAR(NOW()) -1  THEN 'ARCHIVED'
        ELSE 'FUTURE'
		END AS category
FROM orders;

-- exercise
SELECT 
	CONCAT(first_name, ' ',last_name) AS customer, points,
    CASE
    WHEN points > 3000 THEN 'GOLD'
    WHEN points >= 2000 THEN 'SILVER'
    ELSE 'BRONZE'
    END AS category
FROM customers
ORDER BY points DESC;





