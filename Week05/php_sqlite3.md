### Activity 1 - SQLite and PHP

- Open this [PHP sandbox](https://sandbox.onlinephpfunctions.com/).

### Step 1: database creation

<details><summary><b>Importing the library and creating the database (Click me)</b></summary>

```php
<?php

// class MyDB extending functionalities provided by SQLite3 */
class MyDB extends SQLite3 {
  // class constructor
  function __construct() {
    // database file
    $this->open('test.db'); // CHANGE test.db to 'yourname.db' - ex 'marcos.db'
  }
}
// instantiating the MyDB application and creating the database (db) instance
$db = new MyDB();
if(!$db) {
  echo $db->lastErrorMsg();
} else {
  echo "Database opened successfully!\n";
}
```

</details>

### Step 2: table creation

<details><summary><b>Creating table COMPANY (Click me)</b></summary>

```php
// Opening the existing 'test.db' database
   class MyDB extends SQLite3 {
      function __construct() {
         $this->open('test.db'); // CHANGE test.db to 'yourname.db' - ex 'marcos.db'
      }
   }
   // obtaining a connection with the database
   $db = new MyDB();
   if(!$db) {
      echo $db->lastErrorMsg();
   } else {
      echo "Opened database successfully!\n";
   }

// creating the table COMPANY
// for demonstration purposes, this table HAS NO PRIMARY KEY, so you can run
// this code as many times as needed without raising any primary key constraint
$sql =<<<EOF
   CREATE TABLE COMPANY
   (ID      INT NOT NULL, 
    NAME    TEXT NOT NULL,
    AGE     INT NOT NULL,
    ADDRESS CHAR(50),
    SALARY  REAL);
EOF;
// executing the SQL statement
$ret = $db->exec($sql);
// checking the result
if(!$ret){
   echo $db->lastErrorMsg();
} else {
   echo "Table created successfully!\n";
}
// closing the connection with the database
$db->close();
```

</details>

### Step 3: INSERT INTO statement

<details><summary><b>Populating the table COMPANY with some data (Click me)</b></summary>

```php
// Opening the existing 'test.db' database
   class MyDB extends SQLite3 {
      function __construct() {
         $this->open('test.db'); // CHANGE test.db to 'yourname.db' - ex 'marcos.db'
      }
   }
   // obtaining a connection with the database
   $db = new MyDB();
   if(!$db) {
      echo $db->lastErrorMsg();
   } else {
      echo "Opened database successfully!\n";
   }

// Complete the INSERT INTO block below with more rows to be inserted into the COMPANY table
// and then execute the SQL statement
$sql =<<<EOF
   INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
   VALUES (1, 'Paul', 32, 'California', 20000.00 );

   # YOUR CODE HERE
EOF;
// executing the SQL statement
   # YOUR CODE HERE

// checking the result
$ret = $db->exec($sql);
if(!$ret) {
   echo $db->lastErrorMsg();
} else {
   echo "Records inserted successfully!\n";
}
// closing the connection with the database
$db->close();
```

</details>

### Step 4: SELECT..FROM..WHERE block

<details><summary><b>Querying the COMPANY table and retrieving some data (Click me)</b></summary>

```php
// Opening the existing 'test.db' database
   class MyDB extends SQLite3 {
      function __construct() {
         $this->open('test.db'); // CHANGE test.db to 'yourname.db' - ex 'marcos.db'
      }
   }
   // obtaining a connection with the database
   $db = new MyDB();
   if(!$db) {
      echo $db->lastErrorMsg();
   } else {
      echo "Opened database successfully!\n";
   }

   // SELECT statement
   $sql =<<<EOF
      SELECT * FROM COMPANY;
EOF;
   // executing the SQL statement
   $ret = $db->query($sql);
   // fetching the results and iterating over them
   while($row = $ret->fetchArray(SQLITE3_ASSOC) ) {
      echo "ID = ". $row['ID'] . "\n";
      echo "NAME = ". $row['NAME'] ."\n";
      echo "ADDRESS = ". $row['ADDRESS'] ."\n";
      echo "SALARY = ". $row['SALARY'] ."\n\n";
   }
   echo "Operation done successfully!\n";
   // closing the connection with the database
   $db->close();
```

</details>

### Step 5: UPDATE statement

Example: you want to update the salary of a given person based on her/his ID or her/his address.

<details><summary><b>Modifying some data in the COMPANY table (Click me)</b></summary>

```php
// Opening the existing 'test.db' database
   class MyDB extends SQLite3 {
      function __construct() {
         $this->open('test.db'); // CHANGE test.db to 'yourname.db' - ex 'marcos.db'
      }
   }
   // obtaining a connection with the database
   $db = new MyDB();
   if(!$db) {
      echo $db->lastErrorMsg();
   } else {
      echo "Opened database successfully!\n";
   }

   // UPDATE statement
   $sql =<<<EOF
   # YOUR CODE HERE
EOF;
   // executing the SQL statement
   # YOUR CODE HERE
   if(!$ret) {
      echo $db->lastErrorMsg();
   } else {
      echo $db->changes(), " record(s) updated successfully!\n";
   }
   // closing the connection with the database
   $db->close();
```

</details>

### Step 6: repeat Step 4 to check if your UPDATE command has worked as expected.

### Step 7: DELETE statement

Example: you want to remove someone from your database based on her/his ID or her/his address.

<details><summary><b>Deleting data from the COMPANY table (Click me)</b></summary>

```php
// Opening the existing 'test.db' database
   class MyDB extends SQLite3 {
      function __construct() {
         $this->open('test.db'); // CHANGE test.db to 'yourname.db' - ex 'marcos.db'
      }
   }
   // obtaining a connection with the database
   $db = new MyDB();
   if(!$db) {
      echo $db->lastErrorMsg();
   } else {
      echo "Opened database successfully!\n";
   }

   // DELETE statement
   $sql =<<<EOF
   # YOUR CODE HERE
EOF;
   // executing the SQL statement
   # YOUR CODE HERE
   if(!$ret) {
      echo $db->lastErrorMsg();
   } else {
      echo $db->changes(), " record(s) deleted successfully!\n";
   }
   // closing the connection with the database
   $db->close();
```

</details>

### Step 8: again, repeat Step 4 to check if your DELETE command has worked as expected.



