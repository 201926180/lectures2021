# ST207 - DATABASES

# Example code of Python and SQL
# Based on https://stackabuse.com/a-sqlite-tutorial-with-python

# importing SQLite library
import sqlite3
import os

# con = sqlite3.connect('example.db')

# create a default path to connect to and create (if necessary) a database
# called 'example' in the same directory as this script
DEFAULT_PATH = os.path.join(os.path.dirname(__file__), 'example.db')

# generalized function for connecting to a database in a pre-defined path.
def db_connect(db_path=DEFAULT_PATH):
    con = sqlite3.connect(db_path)
    return con

"""
Helper functions for creating tables in this Example.
See Ex_PythonSQL_2.py.
"""
def create_customer(con, first_name, last_name):
    sql = """
        INSERT INTO customers (first_name, last_name)
        VALUES (?, ?)"""
    cur = con.cursor()
    cur.execute(sql, (first_name, last_name))
    return cur.lastrowid

def create_order(con, customer_id, date):
    sql = """
        INSERT INTO orders (customer_id, date)
        VALUES (?, ?)"""
    cur = con.cursor()
    cur.execute(sql, (customer_id, date))
    return cur.lastrowid

def create_lineitem(con, order_id, product_id, qty, total):
    sql = """
        INSERT INTO lineitems
            (order_id, product_id, quantity, total)
        VALUES (?, ?, ?, ?)"""
    cur = con.cursor()
    cur.execute(sql, (order_id, product_id, qty, total))
    return cur.lastrowid
