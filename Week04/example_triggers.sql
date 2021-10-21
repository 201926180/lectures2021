-- EXAMPLE tRIGGERS
-- Based on https://www.w3resource.com/sqlite/sqlite-triggers.php#SDT

-- Creating table to store employees' data
CREATE TABLE emp_details (
	employee_id		INTEGER NOT NULL PRIMARY KEY,
	first_name		TEXT NOT NULL,
	last_name			TEXT NOT NULL,
	email					TEXT,
	phone_number	TEXT,
	hire_date			TEXT,
	job_id				TEXT,
	salary				REAL,
	comission_pct	REAL,
	manager_id		INTEGER,
	department_id	INTEGER
);

-- creating a log table to store any updates on the emp_details table
-- no major constraints in this table (i.e. primary keys, not null values etc)
-- only a foreign key pointing to emp_details
CREATE TABLE emp_log (
	emp_id			INTEGER,
	salary			REAL,
	edittime		INTEGER,
	description	TEXT,
  -- foreign key to emp_details to ensure any log entry is related to an existing employee
	CONSTRAINT	fk_emp
	FOREIGN KEY	(emp_id) REFERENCES	emp_details(employee_id)
);

-- Inserting some data on emp_details
-- Observe that no log messages will be recorded at this moment as the triggers were not defined yet
INSERT INTO emp_details
VALUES 	(100, "Steven", "King", "SKING", "515.123.4567", "6/17/1987", "AD_PRES", 24000, 0, 0, 90),
				(101, "Neena", "Kochhar", "NKOCHHAR", "515.123.4568", "6/18/1987", "AD_VP", 17000, 0, 100, 90),
				(102, "Lex", "De Haan", "LDEHAAN", "515.123.4569", "6/19/1987", "AAD_VP", 17000, 0, 0, 90),
			  (103, "Alexander", "Hunold", "AHUNOLD", "590.423.4567", "6/20/1987", "IT_PROG", 9000, 0, 102, 60),
				(104, "Bruce", "Ernst", "BERNST", "590.423.4568", "6/21/1987", "IT_PROG", 6000, 0, 103, 60),
				(105, "David", "Austin", "DAUSTIN", "5590.423.4569", "6/22/198", "IT_PROG", 4800, 0, 103, 60),
				(106, "Valli", "Pataballa", "VPATABA", "590.423.4560", "6/23/1987", "IT_PRO", 4800, 0, 103, 60),
				(107, "Diana", "Lorentz", "LORENTZ", "590.423.5567", "6/24/1987", "IT_PROG", 4200, 0, 103, 60),
				(108, "Nancy", "Greenberg", "NGREENBE", "515.124.4569", "6/25/1987", "FI_MGR", 12000, 0, 101, 100),
				(109, "Daniel", "Faviet", "DFAVIET", "515.124.4169", "6/26/1987", "FI_ACCOUNT", 9000, 0, 8, 100),
				(110, "John", "Chen", "JCHEN", "515.124.4269", "6/27/1987", "FI_ACCOUNT", 8200, 0, 108, 100),
				(111, "Ismael", "Sciarra", "ISCIARRA", "515.124.4369", "6/28/1987", "FI_ACCOUNT", 7700, 0, 8, 100),
				(112, "Jose Manuel", "Urman", "JMURMAN", "515.124.4469", "6/29/1987", "FI_ACCOUNT", 7800, 0, 108, 100);

-- Let's simulate some previous log messages
-- you can comment these lines for an empty log
INSERT INTO emp_log
VALUES 	(100, 24000, "2011-01-15", "Initial salary"),
				(101, 17000, "2010-01-12", "Initial salary"),
				(102, 17000, "2010-09-22", "Initial salary"),
				(103, 9000, "2011-06-21", "Initial salary"),
				(104, 6000, "2012-07-05", "Initial salary"),
				(105, 4800, "2011-06-02", "Initial salary");

-- #####################
-- Triggers section
-- #####################

-- Basic syntax and parameters for triggers

-- trigger name: unique name for the trigger. Observe that the trigger inherits the schema (aatributes) of its table.
-- BEFORE, AFTER, INSTEAD OF: specifies whether the function is called before, after or instead of an event.
-- database-event:	one of the INSERT, UPDATE, DELETE that will fire the trigger.
-- table-name: the name of the table or view the trigger is for.
-- FOR EACH ROW / STATEMENT: specifies whether the trigger procedure should be fired once for every row affected
	 -- by the trigger event, or just once per SQL statement. If neither is specified, FOR EACH STATEMENT is the default.
-- expression: a Boolean expression that determines whether the trigger function will actually be executed.
-- trigger-step: action for the trigger, it is the sql statement.

-- There is two SQLite extension to triggers 'OLD' and 'NEW'. OLD and NEW are not case sensitive.

-- * Within the trigger body, the OLD and NEW keywords enable you to access columns in the rows affected by a trigger
-- * In an INSERT trigger, only NEW.col_name can be used.
-- * In a UPDATE trigger, you can use OLD.col_name to refer to the columns of a row before it is updated and NEW.col_name to refer to the columns of the row after it is updated.
-- * In a DELETE trigger, only OLD.col_name can be used; there is no new row.

-- AFTER INSERT
-- Actions to be taken after inserting rows in the emp-emp_details table
CREATE TRIGGER aft_insert AFTER INSERT ON emp_details
BEGIN
  -- log the information about a new employee
	INSERT INTO emp_log (emp_id, salary, edittime, description)
	VALUES (NEW.employee_id, NEW.salary, current_date, "Initial salary");
END;

-- Testing the trigger
INSERT INTO emp_details
VALUES (230, 'Rabi', 'Chandra', 'RABI', '590.423.45700', '01/12/2013', 'AD_VP', 15000, .5, 0, 0);

-- BEFORE INSERT
-- Actions to be taken before inserting a row in the emp_details table
CREATE TRIGGER bef_insert BEFORE INSERT ON emp_details
BEGIN
	-- Check if the employee exists
	SELECT CASE
	WHEN ((SELECT emp_details.employee_id FROM emp_details WHERE emp_details.employee_id = NEW.employee_id) IS NOT NULL)
	THEN RAISE(FAIL, 'ERROR: This employee_id does exist.')
END;
END;

-- Testing the trigger
INSERT INTO emp_details(employee_id,first_name,last_name) values (250, 'Jeson', 'Flap');

-- AFTER UPDATE
-- Actions to be taken after updating rows in the emp_details table
CREATE TRIGGER aft_update AFTER UPDATE ON emp_details
BEGIN
	-- log the information about a new salary
	INSERT into emp_log (emp_id, salary, edittime, description)
	VALUES (OLD.employee_id, NEW.salary, current_date, 'Update salary from '|| OLD.salary || ' to ' || NEW.salary);
END;

-- Testing the trigger
UPDATE emp_details SET salary = salary + (salary * 0.05)  WHERE department_id = 60;

-- BEFORE UPDATE
-- Actions to be taken before updating a row in the emp_details table
CREATE TRIGGER bef_update BEFORE UPDATE ON emp_details
BEGIN
	-- Check if the employee_id can be changed
	SELECT CASE
	WHEN ((SELECT emp_details.employee_id FROM emp_details WHERE emp_details.employee_id = NEW.employee_id) IS NULL)
	THEN RAISE(FAIL, 'ERROR: This employee_id can not be updated.')
END;
END;

-- Testing the trigger
UPDATE emp_details SET employee_id = 1000 WHERE email = "DAUSTIN";

-- AFTER DELETE
-- Actions to be taken after deleting rows from the emp_details table
CREATE TRIGGER aft_delete AFTER DELETE ON emp_details
BEGIN
	-- log the information about which employee was removed
	INSERT INTO emp_log (emp_id, description)
	VALUES (OLD.employee_id, 'Deleted on '|| date('NOW'));
END;

-- Testing the trigger
DELETE FROM emp_details WHERE employee_id = 102;

-- BEFORE DELETE
-- Actions to be taken before before deleting rows from the emp_details table
CREATE TRIGGER bef_delete BEFORE DELETE ON emp_details
BEGIN
 	-- Check for foreign key violation
	SELECT CASE
	WHEN (SELECT COUNT(employee_id) FROM emp_details WHERE employee_id=OLD.employee_id) > 0
	THEN RAISE(FAIL, 'ERROR: Foreign Key Violation: emp_details rows reference row to be deleted.')
END;
END;

-- Testing the trigger
-- TO DO: change Daniel to Alex and check the result
DELETE FROM emp_details WHERE first_name = "Daniel";

-- YOUR TURN
-- Create a trigger named 'bef_delete_log' to be applied to the emp_log table
-- the event: DELETE FROM emp_log
-- the condition: the trigger should check whether a salary is greater than 5000
-- the action: raise a fail error (with an error message of your choice)

CREATE TRIGGER bef_delete_log BEFORE DELETE ON emp_log
BEGIN
 	-- Check for salary > 5000
  -- <YOUR CODE HERE>
END;

-- Now test your trigger
-- Write a DELETE command to remove from emp_log:
-- you can choose any row where salary > 5000 and also any row where salary <= 5000 to test your trigger

-- <YOUR CODE HERE>

-- STOP HERE, GO TO example_views.sql AND THEN COME BACK TO RESUME THIS EXAMPLE

-- ####################
-- INSTEAD OF TRIGGER
-- ####################

-- Creating a VIEW to work with the INSTEAD OF trigger
CREATE VIEW emp_details_view AS
	SELECT	employee_id, first_name, last_name, email
	FROM		emp_details
	ORDER BY first_name, last_name;

-- Checking the VIEW
SELECT 'VIEW data';
SELECT * FROM emp_details_view;

-- INSERT TRIGGER using INSTEAD OF
CREATE TRIGGER view_ins_trig INSTEAD OF INSERT ON emp_details_view
BEGIN
	INSERT INTO emp_details(employee_id, first_name, last_name, email)
	SELECT NEW.employee_id, NEW.first_name, NEW.last_name, NEW.email;
END;

-- Now insert the rows in the emp_details_view and the triggers will
-- propagate those changes to the underlying table.
INSERT	INTO emp_details_view (employee_id,first_name,last_name,email)
VALUES	(250, 'Andrai', 'Marku','AND_MAR');

-- Checking the emp_details table
SELECT ' ';
SELECT * FROM emp_details_view;

-- UPDATE TRIGGER using INSTEAD OF
CREATE TRIGGER view_update_trig INSTEAD OF UPDATE ON emp_details_view
BEGIN
	UPDATE	emp_details
	SET			employee_id = NEW.employee_id, first_name = NEW.first_name, last_name = NEW.last_name
	WHERE		employee_id = OLD.employee_id;
END;

-- Now update the rows in the emp_details_view.
UPDATE	emp_details_view
SET 		first_name = 'Rudolph'
WHERE		first_name = 'Bruce' AND last_name= 'Ernst';

-- DELETE TRIGGER using INSTEAD OF
CREATE TRIGGER view_delete_trig INSTEAD OF delete ON emp_details_view
BEGIN
	DELETE FROM emp_details
	WHERE employee_id = OLD.employee_id;
END;

-- Now delete the row from the emp_details_view which employee_id is 108, and look the result.
DELETE FROM emp_details_view
WHERE employee_id = 108;

-- Checking the emp_details table
SELECT ' ';
SELECT * FROM emp_details_view;

-- ##################
-- dropping TRIGGERS
-- ##################

DROP TRIGGER bef_insert;

SELECT 'Finishing the program...';
