-- CREATING A USER
-- GIVING THEM PRIVILEGES: permission to read and write only, shouldnot able to change sturcture of database

-- can only connect from that ip
CREATE USER Milan@127.0.0.1 IDENTIFIED BY 'Milan@123'; 
CREATE USER Milan@localhost IDENTIFIED BY 'Milan@123';
CREATE USER Milan@'%.codewithmosh.com' IDENTIFIED BY 'Milan@123'; -- can connect from computers in this domain/sub domain

-- Viewing users
SELECT * FROM mysql.user;

-- Dropping users
CREATE USER bob@codewithmosh.com IDENTIFIED BY 'bob123';
DROP USER bob@codewithmosh.com;

-- changing passwords
SET PASSWORD FOR Milan = 'change@123';

-- Granting Privileges
-- 1: Web/Desktop application
-- we have application called moon
CREATE USER moon_app IDENTIFIED BY 'moon@12#34*';

-- can only use sql_store database and only read write data, execute stored procedure,cannot change structure of database 
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE
ON sql_store.*
TO moon_app;

-- 2: ADMIN
CREATE USER Milan IDENTIFIED BY 'Milan@123'; 
GRANT ALL ON *.* TO MILAN;

-- VIEWING PRIVILEGES
SHOW GRANTS;

-- REVOKING PRIVILEGES
REVOKE EXECUTE
ON sql_store.*
FROM moon_app;



