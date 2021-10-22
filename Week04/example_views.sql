-- EXAMPLE VIEWS
-- We will be using the Company.db database

-- Open the database
.open Company.db

-- Checking existing tables
.tables

-- Creating a temporary view to store the employee's name and the projects that the employee works on.
-- To persist this view into the database, remove the TEMP clause
CREATE TEMP VIEW IF NOT EXISTS WORKS_ON1 AS
SELECT  Fname, Lname, Pname, Hours
FROM    employee, project, works_on
WHERE   Ssn = Essn AND Pno = Pnumber;

-- Creating a temporary view to store some department information
-- To persist this view into the database, remove the TEMP clause
CREATE TEMP VIEW IF NOT EXISTS DEPT_INFO(Dept_name, No_of_emps, Total_sal) AS
SELECT  Dname, COUNT(*), SUM(salary)
FROM    department, employee
WHERE   Dnumber = Dno
GROUP BY Dname;

-- Querying the views
SELECT ' ';
SELECT  Fname, Lname
FROM    WORKS_ON1
WHERE   Pname = 'ProductX';

SELECT ' ';
SELECT  *
FROM    DEPT_INFO;

-- Updating the views

-- Run these comnands and check the output
UPDATE  WORKS_ON1
SET     Pname = 'ProductY'
WHERE   Fname = 'John' AND Lname = 'Smith' AND Pname = 'ProductX';

UPDATE  DEPT_INFO
SET     Total_sal = 10000
WHERE   Dept_name = 'Research';

-- Inline views

SELECT ROUND(AVG(WORK_HOUR.TotalHours),2) AS Average_Salary
FROM (SELECT SUM(hours) TotalHours FROM works_on GROUP BY Essn) AS WORK_HOUR;

SELECT printf("%.2f", AVG(DEPT_SALARY.TotalSalary)) AS Average_Salary
FROM (SELECT SUM(Salary) TotalSalary FROM employee GROUP BY Dno) AS DEPT_SALARY;

-- YOUR TURN
-- Create a view DEPT_MGR that has the department name, manager name, and manager salary for every department.

-- <YOUR CODE HERE>

-- Create a view that has tje project name, controlling department (number or name), number of employees, and total Hours
-- worked per week on the project for each project

-- <YOUR CODE HERE>
