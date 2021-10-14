-- AGGREGATE FUNCTIONS

-- Find the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary.

SELECT SUM(Salary) AS Total_Salary, MAX(Salary) AS Highest_Salary, MIN(Salary) AS Lowest_Salary, AVG(Salary) AS Average_Salary
  FROM employee;

--We can apply this query to a specific department (e.g. 'Research')

SELECT SUM(Salary) AS Total_Salary, MAX(Salary) AS Highest_Salary, MIN(Salary) AS Lowest_Salary, AVG(Salary) AS Average_Salary
  FROM employee
  JOIN department ON Dno = Dnumber
 WHERE Dname = 'Research';

-- Retrieve the total number of employees in the company

SELECT COUNT(*) AS Total_Number_Employees
  FROM employee;

-- Again, we can apply this to a specific department (e.g. 'Sales')

SELECT COUNT(*) AS Total_Number_Employees
  FROM employee, department
 WHERE Dno = Dnumber AND Dname = 'Sales';

-- Count the number of distinct salaries in the database.

SELECT COUNT(DISTINCT Salary)
  FROM employee;

-- Retrieve the name of employees who have two or more dependents.

SELECT Fname || ' ' || Lname as 'Employee_Name'
  FROM employee
 WHERE (SELECT COUNT(*)
			    FROM dependent
			   WHERE Ssn = Essn) >= 2;

-- For each department, retrieve the department number, the number of employees and the average salary.

SELECT Dno, COUNT(*), ROUND(AVG(Salary),2)
  FROM employee
 GROUP BY Dno;

-- For each project, retrieve the project number, the project name, and the number of employees working on that project

SELECT Pnumber, Pname, COUNT(*)
  FROM project, works_on
 WHERE Pnumber = Pno
 GROUP BY Pnumber, Pname;

-- For each project om which more than 3 employees work, retrieve the project number, the project name, and the number of employees working on that project

SELECT Pnumber, Pname, COUNT(*)
  FROM project, works_on
 WHERE Pnumber = Pno
 GROUP BY Pnumber, Pname
HAVING COUNT(*) > 3;

-- NOTE: The following query is semantically incorrect! Try to figure out why!

-- Count the total number of employees whose salaries exceed $40000 in each department, but only for departments where more than five employees work.

SELECT Dno, COUNT(*)
  FROM employee
 WHERE Salary > 40000
 GROUP BY Dno
HAVING COUNT(*) > 5;

-- Correct query: for each department that has more than five employees, retrieve the department number and the number of employees who are making more than $40000.

SELECT Dno, COUNT(*)
  FROM employee
 WHERE Salary > 40000 AND Dno IN
			 (SELECT Dno
	 		 		FROM employee
	 			 GROUP BY Dno
	 		 	HAVING COUNT(*) > 5)
 GROUP BY Dno;

-- ADDITIONAL SQL CONSTRUCTS

-- WITH: this clause allows the user to define a table that will only be used in a particular query.
-- As this is not part of the standard SQL, this construct may be not supported in some SQL-based DBMS.

-- The previous query can be rewritten using WITH: for each department that has more than five employees, retrieve the department number
-- and the number of employees who are making more than $40000.

WITH BigDepts (Dno) AS
		 (SELECT Dno
	 	 		FROM employee
	 		 GROUP BY Dno
	 	 	HAVING COUNT(*) > 5)
SELECT Dno, COUNT(*)
	FROM employee
 WHERE Salary > 40000 AND Dno IN BigDepts
 GROUP BY Dno;

-- RECURSIVE QUERY: this is useful to explore recursive relationships inside the database.

-- Example: we can explore each employee tuple (in the role of a supervisee) in relation to another employee tuple (in the role of supervisor) at all levels.
-- An supervisor E and all the supervisees E', all the supervisees E'' supervised by each E', and so on.

WITH RECURSIVE SUP_EMP(SupSsn, EmpSsn) AS
		 (SELECT Super_ssn, Ssn
	 	 		FROM employee
	 		 UNION
	 	 	SELECT E.Ssn, S.SupSsn
	 			FROM employee AS E, SUP_EMP AS S
	 		 WHERE E.Super_ssn = S.EmpSsn)
SELECT *
  FROM SUP_EMP;
