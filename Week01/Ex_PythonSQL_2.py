# ST207 - DATABASES

# Example code of Python and SQL
# Based on https://stackabuse.com/a-sqlite-tutorial-with-python

# importing necessary libraries
import sqlite3
# see auxiliary file db_utils
from db_utils import db_connect

# The code below creates a connection object then uses it to instantiate a cursor object.
# The cursor object is used to execute SQL statements on the SQLite database.
# connect to the database
con = db_connect()
# instantiate a cursor obj
cur = con.cursor()

# Creating Tables

customers_sql = """
    CREATE TABLE customers (
        id integer PRIMARY KEY,
        first_name text NOT NULL,
        last_name text NOT NULL)"""

cur.execute(customers_sql)

products_sql = """
    CREATE TABLE products (
        id integer PRIMARY KEY,
        name text NOT NULL,
        price real NOT NULL)"""

cur.execute(products_sql)

# We can query the ``sqlite_master table``, a built-in SQLite metadata table, to verify that
# the above commands were successful.

# To see all the tables in the currently connected database query the name column of
# the sqlite_master table where the type is equal to "table".
cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
print(cur.fetchall())

# To get a look at the schema of the tables query the sql column of the same table
# where the type is still "table" and the name is equal to "customers" and/or "products".
cur.execute("""SELECT sql FROM sqlite_master WHERE type='table' AND name='customers'""")
print(cur.fetchone()[0])

# The next table to define will be the orders table which associates customers to orders
# via a foreign key and the date of their purchase. Since SQLite does not support an actual
# date/time data type (or data class to be consistent with the SQLite vernacular) all dates
# will be represented as text values.
orders_sql = """
    CREATE TABLE orders (
        id integer PRIMARY KEY,
        date text NOT NULL,
        customer_id integer,
        FOREIGN KEY (customer_id) REFERENCES customers (id))"""

cur.execute(orders_sql)

# The final table to define will be the line items table which gives a detailed
# accounting of the products in each order.
lineitems_sql = """
    CREATE TABLE lineitems (
        id integer PRIMARY KEY,
        quantity integer NOT NULL,
        total real NOT NULL,
        product_id integer,
        order_id integer,
        FOREIGN KEY (product_id) REFERENCES products (id),
        FOREIGN KEY (order_id) REFERENCES orders (id))"""
cur.execute(lineitems_sql)

# Loading the Data

# Let's populate the products table first because without
# products we cannot have a sale and thus would not have the foreign keys to relate to the
# line items and orders
product_sql = "INSERT INTO products (name, price) VALUES (?, ?)"
cur.execute(product_sql, ('Introduction to Combinatorics', 7.99))
cur.execute(product_sql, ('A Guide to Writing Short Stories', 17.99))
cur.execute(product_sql, ('Data Structures and Algorithms', 11.99))
cur.execute(product_sql, ('Advanced Set Theory', 16.99))

"""
The above code probably seems pretty obvious, but let me discuss it a bit as
there are some important things going on here. The insert statement follows
the standard SQL syntax except for the ? bit. The ?'s are actually placeholders
in what is known as a "parameterized query".

Parameterized queries are an important feature of essentially all database
interfaces to modern high level programming languages such as the sqlite3
module in Python. This type of query serves to improve the efficiency of
queries that are repeated several times. Perhaps more important, they also
sanitize inputs that take the place of the ? placeholders which are passed
in during the call to the execute method of the cursor object to prevent
nefarious inputs leading to SQL injection.
"""

"""
To populate the remaining tables we are going to follow a slightly different
pattern to change things up a bit. The workflow for each order, identified by
a combination of customer first and last name and the purchase date, will be:

Insert the new customer into the customers table and retrieve its primary key id
Create an order entry based off the customer id and the purchase date then retrieve
its primary key id for each product in the order determine its primary key id and
create a line item entry associating the order and the product
"""
cur.execute("SELECT id, name, price FROM products")
formatted_result = [f"{id:<5}{name:<35}{price:>5}" for id, name, price in cur.fetchall()]
id, product, price = "Id", "Product", "Price"
print('\n'.join([f"{id:<5}{product:<35}{price:>5}"] + formatted_result))

# Start by making a new customer record for Mr. Turing then determine his primary key id
# by accessing the lastrowid field of the cursor object.
customer_sql = "INSERT INTO customers (first_name, last_name) VALUES (?, ?)"
cur.execute(customer_sql, ('Alan', 'Turing'))
customer_id = cur.lastrowid
print(customer_id)

# We can now create an order entry, collect the new order id value and associate it
# to a line item entry along with the product Mr. Turing ordered.
order_sql = "INSERT INTO orders (date, customer_id) VALUES (?, ?)"
date = "1944-02-22" # ISO formatted date
cur.execute(order_sql, (date, customer_id))
order_id = cur.lastrowid
print(order_id)

li_sql = """INSERT INTO lineitems (order_id, product_id, quantity, total) VALUES (?, ?, ?, ?)"""
product_id = 1
cur.execute(li_sql, (order_id, 1, 1, 7.99))

"""
The remaining records are loaded exactly the same except for the order made to Donald Knuth,
which will receive two line item entries. However, the repetitive nature of such a task is
crying out the need to wrap these functionalities into reusable functions.

Have a look at db_utils.py for some helpful functions used in the following commands.
"""
# importing auxiliary functions
from db_utils import create_customer, create_order, create_lineitem

# con = db_connect()
knuth_id = create_customer(con, 'Donald', 'Knuth')
knuth_order = create_order(con, knuth_id, '1967-07-03')
knuth_li1 = create_lineitem(con, knuth_order, 2, 1, 17.99)
knuth_li2 = create_lineitem(con, knuth_order, 3, 1, 11.99)
codd_id = create_customer(con, 'Edgar', 'Codd')
codd_order = create_order(con, codd_id, '1969-01-12')
codd_li = create_lineitem(con, codd_order, 4, 1, 16.99)

# Wrapping commands into transactions for easy commit or rollback

# When you find yourself doing multiple database manipulations (INSERTs in this case)
# in order to accomplish what is actually one cumulative task (ie, creating an order)
# it is best to wrap the subtasks (creating customer, order, then line items) into a
# single database transaction so you can either commit on success or rollback if an
# error occurs along the way.
try:
    codd_id = create_customer(con, 'Edgar', 'Codd')
    codd_order = create_order(con, codd_id, '1969-01-12')
    codd_li = create_lineitem(con, codd_order, 4, 1, 16.99)
    # commit the statements
    con.commit()
except:
    # rollback all database actions since last commit
    con.rollback()
    raise RuntimeError("Uh oh, an error occurred ...")

# quick demonstration of how to UPDATE an existing record in the database.
# Let's update the Guide to Writing Short Stories' price to 10.99 (going on sale).
update_sql = "UPDATE products SET price = ? WHERE id = ?"
cur.execute(update_sql, (10.99, 2))

# Querying the Database

# To perform a basic multirow query of the customers table you pass a SELECT
# statement to the execute(...) method of the cursor object. After this you can
# iterate over the results of the query by calling the fetchall() method of
# the same cursor object.
cur.execute("SELECT id, first_name, last_name FROM customers")
results = cur.fetchall()
for row in results:
    print(row)

# Lets say you would like to instead just retrieve one record from the database.
# You can do this by writing a more specific query, say for Donald Knuth's id of 2,
# and following that up by calling fetchone() method of the cursor object.
cur.execute("SELECT id, first_name, last_name FROM customers WHERE id = 2")
result = cur.fetchone()
print(result)

"""
See how the individual row of each result is in the form of a tuple? Well while
tuples are a very useful Pythonic data structure for some programming use cases
many people find them a bit hindering when it comes to the task of data retrieval.
It just so happens that there is a way to represent the data in a way that is perhaps
more flexible to some. All you need to do is set the row_factory method of the
connection object to something more suitable such as sqlite3.Row. This will give
you the ability to access the individual items of a row by position or keyword value.
"""
con.row_factory = sqlite3.Row
cur = con.cursor()
cur.execute("SELECT id, first_name, last_name FROM customers WHERE id = 2")
result = cur.fetchone()
id, first_name, last_name = result['id'], result['first_name'], result['last_name']
print(f"Customer: {first_name} {last_name}'s id is {id}")
