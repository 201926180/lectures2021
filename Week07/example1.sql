-- creating an example table
CREATE TABLE emp_master
(emp_id INTEGER PRIMARY KEY AUTOINCREMENT,
first_name TEXT,
last_name TEXT,
salary NUMERIC,
dept_id INTEGER);

-- populating some data
INSERT INTO emp_master
values (1,'Honey','Patel', 10100,1),
(2,'Shweta','Jariwala', 19300,2),
(3,'Vinay','Jariwala', 35100,3),
(4,'Jagruti','Viras', 9500,2),
(5,'Shweta','Rana',12000,3),
(6,'sonal','Menpara', 13000,1),
(7,'Yamini','Patel', 10000,2),
(8,'Khyati','Shah', 50000,3),
(9,'Shwets','Jariwala',19400,2);

-- querying the table
SELECT * FROM emp_master;

-- starting a transaction, deleting some data, and asking for rollback
BEGIN TRANSACTION;
DELETE FROM emp_master WHERE dept_id=3;
ROLLBACK;

-- querying the table
SELECT * FROM emp_master;

-- starting a transaction, deleting some data, and commiting the changes
BEGIN TRANSACTION;
DELETE FROM emp_master WHERE emp_id=1;
COMMIT;
