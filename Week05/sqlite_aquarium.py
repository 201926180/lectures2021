# ST207 - DATABASES

# Example code of Python and SQL
# Based on https://www.digitalocean.com/community/tutorials/how-to-use-the-sqlite3-module-in-python-3

# importing SQLite library
import sqlite3

# Step 1 — Creating a Connection to a SQLite Database

# establishing connection the database.
# remember to set a proper path to your file. If the file DOES NOT exist, it will be created.
connection = sqlite3.connect("aquarium.db")

# ``connection.total_changes`` is the total number of database rows that have been
# changed by connection. Since we have not executed any SQL commands yet,
# we expect 0 total_changes as response.
print(connection.total_changes)

# Step 2 — Adding Data to the SQLite Database

# The fish table will track a value for name, species, and tank_number for each fish at
# the aquarium. Two example fish rows are listed: one row for a shark named Sammy, and one
# row for a cuttlefish named Jamie.

# ``connection.cursor()`` returns a Cursor object. Cursor objects allow us to send SQL statements
# to a SQLite database using cursor.execute()
cursor = connection.cursor()

# The "CREATE TABLE fish ..." string is a SQL statement that creates a table named fish with the
# three columns described earlier: name of type TEXT, species of type TEXT, and tank_number of
# type INTEGER.
cursor.execute("CREATE TABLE fish (name TEXT, species TEXT, tank_number INTEGER)")

# Now that we have created a table, we can insert rows of data into it:
cursor.execute("INSERT INTO fish VALUES ('Frankie', 'Shark', 1)")
cursor.execute("INSERT INTO fish VALUES ('Jamie', 'Cuttlefish', 7)")

# alternatively, we can use executescript() to run multiple SQL statements at once
cursor.executescript("""
    INSERT INTO fish VALUES ('Nemo', 'Clownfish', 2);
    INSERT INTO fish VALUES ('Dory', 'Regal Blue Tang', 2);
    INSERT INTO fish VALUES ('Oscar', 'Bluestreak Cleaner Wrasse', 1);
    """)

# Step 3 — Reading Data from the SQLite Database

# We can retrieve those rows using a SELECT SQL statement
rows = cursor.execute("SELECT name, species, tank_number FROM fish").fetchall()
print(rows)

# If we wanted to retrieve rows in the fish table that match a specific set of
# criteria, we can use a WHERE clause
target_fish_name = "Jamie"
rows = cursor.execute(
    "SELECT name, species, tank_number FROM fish WHERE name = ?",
    (target_fish_name,),
).fetchall()
print(rows)

# Step 4 — Modifying Data in the SQLite Database

# Rows in a SQLite database can be modified using UPDATE and DELETE SQL statements.

# Let’s say, for example, that Frankie the shark was moved to tank number 2. We can change
# Sammy’s row in the fish table to reflect this change:
new_tank_number = 2
moved_fish_name = "Frankie"
cursor.execute(
    "UPDATE fish SET tank_number = ? WHERE name = ?",
    (new_tank_number, moved_fish_name)
)

# If we run the following SELECT statement, we can confirm our update was made correctly:
rows = cursor.execute("SELECT name, species, tank_number FROM fish").fetchall()
print(rows)

# Let’s say that Sammy the shark was released into the wild and no longer held by the aquarium.
# Since Sammy no longer lives at the aquarium, it would make sense to remove the Sammy row from
# the fish table.

# Issue a DELETE SQL statement to remove a row:
released_fish_name = "Dory"
cursor.execute(
    "DELETE FROM fish WHERE name = ?",
    (released_fish_name,)
)

# # If we run the following SELECT statement, we can confirm our delte was made correctly:

rows = cursor.execute("SELECT name, species, tank_number FROM fish").fetchall()
print(rows)

# Step 5 — Using with Statements For Automatic Cleanup

# We can use a with statement to help us automatically close Connection and Cursor objects:
from contextlib import closing

# closing is a convenience function provided by the contextlib module. When a with statement exits,
# closing ensures that close() is called on whatever object is passed to it. The closing function
# is used twice in this example. Once to ensure that the Connection object returned by
# sqlite3.connect() is automatically closed, and a second time to ensure that the Cursor object
# returned by connection.cursor() is automatically closed.

# If we run this code, we will see output like [(1,)]
with closing(sqlite3.connect("aquarium.db")) as connection:
    with closing(connection.cursor()) as cursor:
        rows = cursor.execute("SELECT 1").fetchall()
        print(rows)

# Since "SELECT 1" is a SQL statement that always returns a single row with a single
# column with a value of 1, it makes sense to see a single tuple with 1 as its only value
# returned by the code.
