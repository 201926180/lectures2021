## Seminar 06 - Transaction management and concurrency

This short seminar covers some introductory examples on **transaction management and concurrency** in SQLite.

### Activity 1 - SQLite `ROLLBACK`/ `COMMIT`

Before you begin, have a look at [this tutorial](https://www.tutorialspoint.com/sqlite/sqlite_transactions.htm) on SQLite tutorials with a good summary of the main concepts and commands you need for declaring and managing transactions.

Run this [small SQLite script](./example1.sql) for creating a table, inserting some data, and defining transactions to observe the `ROLLBACK` and the `COMMIT` mechanisms.

### Activity 2 - Recap on Python's `sqlalchemy` commit mechanisms

Go to Week05's examples (`ex1_sqlalchemy.ipynb` and `ex2_sqlalchemy_Core.ipynb`) again and pay special attention to the use of the `Connection.commit()` for ensuring all mechanism for ensuring that all updates will be persisted into the database files.

Also, check this [StackOverflow](https://stackoverflow.com/questions/58919301/when-does-sqlite3-roll-back-transactions-in-python-and-when-doesnt-it) post commenting on the **SQLite autocommit** mode versus the standard Python behaviour; and thus why we need to run `connection.commit()` to persist our transactions.

### Homework:

Read this post about [Concurrent writes in SQLite](https://softwareengineering.stackexchange.com/questions/340550/why-are-concurrent-writes-not-allowed-on-an-sqlite-database).

Check the [SQLAlchemy documentation](https://docs.sqlalchemy.org/en/14/dialects/sqlite.html?highlight=transaction) on **database locking behaviour / concurrency**.

[In this post](https://stackoverflow.com/questions/393554/python-sqlite3-and-concurrency), some ideas on how you can explore multithreading and multiprocessing in Python for running multiple queries.

### References

- [SQLite documentation on transactions](https://www.sqlite.org/lang_transaction.html)
- [SQLite syntax for transactions](http://devdoc.net/database/sqlite-3.0.7.2/lang_transaction.html)

Some additional readings

- [Python Database Concurrency Control](https://github.com/robertclaus/python-database-concurrency-control)
- Manning - [5 Non-blocking database drivers](https://livebook.manning.com/book/concurrency-in-python-with-asyncio/chapter-5/v-6/1)
