# Based on https://charlesleifer.com/blog/using-sqlite-full-text-search-with-python/
# How to use SQLite full-text search with Python (and a lot of help from peewee ORM).
# We will see how to index content for searching, how to perform searches, and how to order
# search results using two ranking algorithms.

# This example uses some Peewee's extensions which are collected under the
# [playhouse namespace](http://docs.peewee-orm.com/en/latest/peewee/playhouse.html).

# importing necessary libraries
from peewee import *
from playhouse.sqlite_ext import *

# creating the database
db = SqliteExtDatabase('blog.db')

# creating the models

# we'll create a really basic blog entry model that has a title and a content field.
# In reality you may have a number of other fields like status, timestamp, etc, but since
# the other columns have no effect on the rest of the implementation, I will skip them.
class Entry(Model):
    title = TextField()
    content = TextField()
    # You may have any number of other fields, such as status, timestamp, etc.

    class Meta:
        database = db  # override to specify the database to be used

# We now need to create a special model for storing and indexing the entry content.
# Since each row in the index table will correspond exactly to one blog entry, we can specify
# the entry as the primary key. If you have multiple columns you wish to search, such as a title
# and a content field, you could add them to the FTSEntry model or just concatenate the data together
# and dump it into a single text field. For simplicity we'll do the latter and store everything in a single content field:
class FTSEntry(FTSModel):
    content = TextField()

    class Meta:
      database = db # override to specify the database to be used

# Sorting by relevance

# The idea is that we will use the SQLite [matchinfo function](https://www.sqlite.org/fts5.html#matchinfo),
# which returns information about term counts, to rank the result rows.

# The *blob* returned by `matchinfo()` contains several fields:

#- `p`: the number of matchable phrases in the query.
#- `c`: the number of user-defined columns on the FTS table, excluding docid or any hidden meta-columns.
#- `x`: for each combination of column and phrase (c * p), return three values:
#    - the number of times the phrase appears in the column for the current row.
#    - the total number of times the phrase appears in the column across all rows.
#    - the total number of rows in the FTS table which contain the phrase in the column.

# The matchinfo() function returns a blob of 32-bit unsigned ints for each value, so we will
# need to convert this data to a Python list of int:
def _parse_match_info(buf):
    bufsize = len(buf)  # Length in bytes.
    return [struct.unpack('@I', buf[i:i+4])[0] for i in range(0, bufsize, 4)]

# The length of the matchinfo data varies depending on the number of phrases in the search
# query, and the number of columns on the table being queried. Our rank function will determine
# the number of phrases and columns, then calculate a sum of counts, which we will treat as the
# rank of the document:
def rank(raw_match_info):
# handle match_info called w/default args 'pcx'
# - based on the example rank function => http://sqlite.org/fts3.html#appendix_a
    match_info = _parse_match_info(raw_match_info)
    score = 0.0
    p, c = match_info[:2]
    for phrase_num in range(p):
        phrase_info_idx = 2 + (phrase_num * c * 3)
        for col_num in range(c):
            col_idx = phrase_info_idx + (col_num * 3)
            x1, x2 = match_info[col_idx:col_idx + 2]
            if x1 > 0:
                score += float(x1) / x2
    return -score
