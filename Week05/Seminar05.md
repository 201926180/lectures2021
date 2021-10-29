## Seminar 05 - Database programming techniques

Most database access in practical applications is accomplished through software programs that implement **database programming**.
This software is usually developed in a **general-purpose programming language**, such as Java, C/C++/C# and COBOL (historically), or some **scripting language**, such as PHP, Python, and JavaScript, to allow for accessing databases from Web applications.

During the lecture, we have discussed about different approaches for database programming:

* embedded SQL,
* library of classes and functions, and
* new programming languages (including stored procedures).

This seminar concentrates on the second approach -- **library of classes and functions** - for accessing a database from a particular application.

- Activity 1: shows how you can access SQLite from a PHP application.
- Activity 2: small recap on how you can use the Python `sqlite3` library (based on examples discussed in Week01 and Week04).
- Activity 3: shows how you can use the Python `sqlalchemy` library, CORE API, for acessing and manipulating a database.

Also, have a look at the Homework section with examples on the SQLAlchemy ORM API and the Python `peewee` library, both allowing for object-relational mapping.

### Activity 1 - SQLite and PHP

[PHP](https://www.php.net/) is a popular general-purpose scripting language that is especially suited to Web development.

Check the [PHP SQLite3](https://www.php.net/manual/en/book.sqlite3.php) documentation.

#### Action items:

- Open this [PHP sandbox](https://sandbox.onlinephpfunctions.com/).
- Open the [php_sqlite3.md](./php_sqlite3.md) and follow the instructions for a step-by-step introduction on how to create a database, connect to it, and then create, populate, and access some tables.

### Activity 2 - Recap on Python's `sqlite3` library

If you haven't seen these examples yet, open these notebooks for an introductory look at how to create and manipulate an SQLite database in Python.

- [sqlite3_aquarium.ipynb](./sqlite3_aquarium.ipynb) - creates a toy database for a fictional aquarium and shows how to perform basic DDL and DML operations.
- [ex_database_python.ipynb](./ex_database_python.ipynb) - creates an University database, based on input CSV files and Pandas dataframes, and performs some DDL and DML operations.

### Activity 3 - SQLAlchemy library

[SQLAlchemy](https://www.sqlalchemy.org/) is defined as a Python SQL toolkit that manages a database as a *relational algebra engine* and thus performing a series of optimizations related to the database size and performance. It also provides a *data mapper pattern* component which allows for classes (basic abstraction for most applications) to be mapped into database objects.

SQLAlchemy has two distinct APIs, **Core** and **ORM**, one building on top of the other:

- `SQLAlchemy Core` is the foundational architecture for SQLAlchemy as a database toolkit. The library provides tools for managing connectivity to a database, interacting with database queries and results, and programmatic construction of SQL statements.

- `SQLAlchemy ORM` builds upon the Core to provide optional object relational mapping capabilities. The ORM provides an additional configuration layer allowing user-defined Python classes to be mapped to database tables and other constructs, as well as an object persistence mechanism known as the Session. It then extends the Core-level SQL Expression Language to allow SQL queries to be composed and invoked in terms of user-defined objects.

#### Action items:

Have a look at these examples:

- [ex1_sqlalchemy.ipynb](./ex1_sqlalchemy.ipynb): introducing basic concepts about Core and ORM styles and how to setup a `Engine` connection.
- [ex2_sqlalchemy_Core.ipynb](./ex2_sqlalchemy_Core.ipynb): showing how to define database objects and manipulate data using the Core API.

### Homework: ORM (object-relational mapping) examples

#### A) SQLAlchemy library - ORM API

Revise [ex1_sqlalchemy.ipynb](./ex1_sqlalchemy.ipynb) and then open and run the following notebook.

- [ex3_sqlalchemy_ORM.ipynb](./ex3_sqlalchemy_ORM.ipynb): showing how to define database objects and manipulate data using the ORM API.

#### B) Peewee library

[Peewee](http://docs.peewee-orm.com/en/latest/) is a simple and small ORM ([object-relational mapping](https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping)) library for Python that allows for mapping object-oriented abstractions (i.e. classes) into database objects.

Have a look at these two examples:
- [ex1_peewee.ipynb](./ex1_peewee.ipynb): introducing basic concepts (Model class, Field instance, and Model instance) and how to use Peewee for storing and querying data.
- [ex2_peewee.ipynb](./ex2_peewee.ipynb): showing how to perform full-text search through the FTS module.

### References

- [SQLite - Java tutorial](https://www.tutorialspoint.com/sqlite/sqlite_java.htm)
- [SQLite - PHP tutorial](https://www.tutorialspoint.com/sqlite/sqlite_php.htm)
