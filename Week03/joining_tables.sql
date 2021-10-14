-- JOINING TABLES

-- INNER JOIN: matches each row from the DEPARTMENT table with every row from the PROJECT table based
-- on the join condition (department.Dnumber = project.Dnum) specified after the ON keyword.
-- If the join condition evaluates to true (or 1), the columns of rows from both tables are included in the result set.

SELECT Dnumber, Dname, Pname, Plocation
  FROM department
 INNER JOIN project ON department.Dnumber = project.Dnum
 ORDER BY 1 ASC;

-- In case the column names of joined tables are the same e.g., Dnumber, we can use the USING syntax as follows:

SELECT Dnumber, Dname, Dlocation
  FROM department
 INNER JOIN dept_locations USING (Dnumber)
 ORDER BY 1 ASC;

-- LEFT JOIN: selects data starting from the left table (EMPLOYEE) and matching rows in the right table (DEPENDENT) based on the join condition ().
-- The left join returns all rows from the left table and the matching rows from the right table.
-- If a row from the left table doesn’t have a matching row in the right table, SQLite includes columns of the rows in the left table and NULL for the columns of the right table.

SELECT Ssn, Fname, Lname, Dependent_name, Relationship
  FROM employee
  LEFT JOIN dependent ON employee.Ssn = dependent.Essn
 ORDER BY Ssn;

-- CROSS JOIN (CARTESIAN PRODUCT): combines every row from the first table (table1) with every row from the second table (table2) to form the result set.
-- If the first table has N rows, the second table has M rows, the final result will have NxM rows.
-- NOTE: this usually applies to tables that don't have a direct Relationship (eg primary or foreign key) but need to be combined for executing a given query.
-- Unlike the INNER JOIN and LEFT JOIN clauses, a CROSS JOIN doesn’t have a join condition.

SELECT Pname as Project, Dependent_name as Dependent_Person
  FROM project
 CROSS JOIN dependent;

-- SELF-JOIN: The self-join is a special kind of joins that allow you to join a table to itself using either LEFT JOIN or INNER JOIN clause.
-- You use self-join to create a result set that joins the rows with the other rows within the same table.
-- Because you cannot refer to the same table more than one in a query, you need to use a table alias to assign the table a different name when you use self-join.
-- The self-join compares values of the same or different columns in the same table. Only one table is involved in the self-join.
-- You often use self-join to query parents/child relationship stored in a table or to obtain running totals.

SELECT E.Fname || ' ' || E.Lname as 'Employee_Staff', ES.Fname || ' ' || ES.Lname as 'Supervisor'
  FROM employee E
 INNER JOIN employee ES ON ES.Ssn = E.Super_ssn;
 ORDER BY 'Supervisor';

-- Changing to to LEFT JOIN to retrieve all employees who do not report to anyone.

SELECT E.Fname || ' ' || E.Lname as 'Employee_Staff', ES.Fname || ' ' || ES.Lname as 'Supervisor'
  FROM employee E
  LEFT JOIN employee ES ON ES.Ssn = E.Super_ssn
 ORDER BY 'Supervisor';

-- FULL OUTER JOIN: In theory, the result of the FULL OUTER JOIN is a combination of a LEFT JOIN and a RIGHT JOIN.
-- The result set of the full outer join has NULL values for every column of the table that does not have a matching row in the other table.
-- For the matching rows, the FULL OUTER JOIN produces a single row with values from columns of the rows in both tables.

-- In SQLite, we need to EMULATE a FULL OUTER JOIN using LEFT JOIN and UNIION.
-- In this example, we will emulate a FULL OUTER JOIN between employee and dependent tables using the Ssn and Essn attributes.

SELECT E.Ssn, E.Fname || ' ' || E.Lname as 'Name', D.Dependent_name, D.Relationship
  FROM employee E
  LEFT JOIN dependent D ON E.Ssn = D.Essn
 UNION ALL
SELECT E.Ssn, E.Fname || ' ' || E.Lname as 'Name', D.Dependent_name, D.Relationship
  FROM dependent D
  LEFT JOIN employee E ON D.Essn = E.Ssn
 WHERE E.Ssn IS NULL;

-- How the query works:

-- As SQLilte does not support the RIGHT JOIN clause, we use the LEFT JOIN clause in the second SELECT statement instead
-- and switch the positions of the employee and dependent tables.

-- The UNION ALL clause retains the duplicate rows from the result sets of both queries.

-- The WHERE clause in the second SELECT statement removes rows that already included in the result set of the first SELECT statement.

-- Notice that we are selecting columns from both tables in the same order.
