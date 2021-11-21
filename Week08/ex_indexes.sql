
-- INDEXES IN SQLite

CREATE TABLE Products (
	product_id INT NOT NULL,
	product_name text NOT NULL,
	supplier text NOT NULL
);

-- inserting some data into Products
INSERT INTO Products values(10, 'box', 's1');
INSERT INTO Products values(20, 'paper', 's2');
INSERT INTO Products values(30, 'tape', 's1');

-- creating an index for a single attribute
CREATE INDEX idx_prod ON Products(product_id);

CREATE TABLE Parts (
	part_id INT NOT NULL,
	part_name text NOT NULL,
	supplier text NOT NULL,
	PRIMARY KEY(part_id)
);

-- inserting some data into Parts
INSERT INTO Parts values(1, 'pt1', 's1');
INSERT INTO Parts values(2, 'pt2', 's2');
INSERT INTO Parts values(3, 'pt3', 's1');

CREATE TABLE Contacts (
	first_name text NOT NULL,
	last_name text NOT NULL,
	email text NOT NULL
);

-- creating an unique index for Contacts
CREATE UNIQUE INDEX idx_contacts_email ON Contacts(email);

INSERT INTO Contacts (first_name, last_name, email)
VALUES('John','Doe','john.doe@sqlitetutorial.net');

-- inserting a duplicate key into the UNIQUE index => error
INSERT INTO Contacts (first_name, last_name, email)
VALUES('Johny','Doe','john.doe@sqlitetutorial.net');

INSERT INTO Contacts (first_name, last_name, email)
VALUES('David','Brown','david.brown@sqlitetutorial.net'),
      ('Lisa','Smith','lisa.smith@sqlitetutorial.net');

-- retrieving data through the unique index
SELECT first_name, last_name
FROM contacts
WHERE email = 'lisa.smith@sqlitetutorial.net';

-- creating a composite index
CREATE INDEX idx_contacts_name
ON contacts (first_name, last_name);

-- retrieving data using the composite index
SELECT email
FROM contacts
WHERE first_name = 'John' AND last_name = 'Doe';

-- retrieving data using part of the composite index
SELECT email
FROM contacts
WHERE first_name = 'John';

-- retrieving data using part of the composite index
SELECT email
FROM contacts
WHERE last_name = 'Doe';

-- Which indexes do we have?
-- SQLite Show Indexes

-- retrieving metadata information from the sqlite_master table
SELECT type, name, tbl_name, sql
FROM   sqlite_master
WHERE  type = 'index';

-- removing indexes
DROP INDEX idx_contacts_name;
