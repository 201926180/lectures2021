-- PATTERN MATCHING

-- SQLite provides two wildcards for constructing patterns. They are percent sign % and underscore _ :

-- The percent sign % wildcard matches any sequence of zero or more characters.
-- The underscore _ wildcard matches any single character.

-- LIKE:  To query data based on partial information, you use the LIKE operator in the WHERE clause of the SELECT statement.
-- Example: retrieve all dependents born in the 70s (1970-1979)

SELECT	*
  FROM	dependent
 WHERE	Bdate LIKE "%197%";

--Retrieve all employees whose names start with J

SELECT	*
  FROM	employee
 WHERE	Fname LIKE "J%";

-- Find all employees whose Ssn terminates with '10' followed by a single number (e.g 100, 101 etc).

SELECT	*
  FROM	employee
 WHERE	Ssn LIKE "%10_";

-- IMPORTANT: for Unicode characters that are not in the ASCII ranges, the LIKE operator is case sensitive e.g., "Ä" LIKE "ä" is false.
-- In case you want to make LIKE operator works case-sensitively, you need to use the following PRAGMA:

PRAGMA case_sensitive_like = true;

-- For example, this query DOES NOT return any details from the project 'ProjectX' although it exists in the DATABASE

SELECT * FROM project WHERE Pname = 'Productx';

-- ESCAPE character: If the pattern that you want to match contains % or _, you must use an escape character in an optional ESCAPE
-- clause as follows:
-- column_1 LIKE pattern ESCAPE expression;

-- When you specify the ESCAPE clause, the LIKE operator will evaluate the expression that follows the ESCAPE keyword to a string which consists of a single character, or an escape character.

-- Then you can use this escape character in the pattern to include literal percent sign (%) or underscore (_).  The LIKE operator evaluates the percent sign (%) or underscore (_) that follows the escape character as a literal string, not a wildcard character.

-- For this example, we will create a temporary table with some % data on it.

CREATE TABLE temp (
	   c TEXT
);

INSERT INTO temp(c)
VALUES ('10% increase'),
			 ('10 times decrease'),
			 ('100% vs. last year'),
			 ('20% increase next year');

SELECT * FROM temp;

-- Suppose you want to match the string 10% in a column of a table. However, SQLite interprets the percent symbol % as the
-- wildcard character.

SELECT c
  FROM temp
 WHERE c LIKE '%10%%';

-- Therefore,  you need to escape this percent symbol % using an escape character:

SELECT c
  FROM temp
 WHERE c LIKE '%10\%%' ESCAPE '\';

-- Can we use other ESCAPE characters?

-- For example, for inserting data with single quotes, we can enclose the string with double quotes, and vice-versa.

insert into temp(c) values("Databases' lesson");

insert into temp(c) values(' "Hey! Databases!" ');

select * FROM temp;

-- GLOB:  The GLOB operator is similar to the LIKE operator. The GLOB operator determines whether a string matches a specific pattern.
-- Unlike the LIKE operator, the GLOB operator is case sensitive and uses the UNIX wildcards. In addition, the GLOB patterns do not have escape characters.

-- The following shows the wildcards used with the GLOB  operator:

-- The asterisk (*) wildcard matches any number of characters.
-- The question mark (?) wildcard matches exactly one character.

-- Find the projects which names start with 'Prod'.

SELECT	*
  FROM 	project
 WHERE	Pname GLOB 'Prod*';

-- Find the employees who live in Texas.

SELECT	*
  FROM 	employee
 WHERE	Address GLOB '*TX';

-- Find the employees whose last name starts with 'J' followed by two single (any) charachter and ends with 'ES'.

SELECT	*
  FROM	employee
 WHERE	Lname GLOB 'J??es';
