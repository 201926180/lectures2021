-- “Full Text Search” with SQLite
-- Based on https://medium.com/hackernoon/sqlite-the-unknown-feature-edfa73a6f022

-- FTS5 module
-- FTS5 is an SQLite virtual table module that provides full-text search functionality to database applications.
-- See documentation here => https://www.sqlite.org/fts5.html

-- This example will extract some reviews from the Moroccan beautiful Riad “Riad Al Mamoune” and search on them.

-- First, create the database
SELECT 'Creating database...';
.open hotels_reviews.db

-- create the table that stores hotel reviews
SELECT 'Creating table...';
CREATE TABLE hotels_reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
review TEXT NOT NULL
);

-- We need to create a virtual table for hotels_reviews that hosts indices for the data
-- This example uses the "porter" tokenizer => https://www.sqlite.org/fts3.html#tokenizer
SELECT 'Creating virtual table index...';
CREATE VIRTUAL TABLE hotels_reviews_index USING fts5(review, tokenize=porter);

-- ##########################
-- TRIGGERS section
-- ##########################
-- We need to keep the two table hotels_reviews and hotels reviews_index in sync,
-- as we add or update or delete, trigger can do the trick
-- rowid is a special column on the virtual table that store the unique value of the row.
-- in our example we use the same primary key of hotels_reviews

-- Trigger on CREATE
SELECT 'Creating triggers...';

CREATE TRIGGER after_hotels_reviews_insert AFTER INSERT ON hotels_reviews
BEGIN
  INSERT INTO hotels_reviews_index (rowid, review)
  VALUES(new.id, new.review);
END;

-- Trigger on UPDATE
CREATE TRIGGER after_hotels_reviews_update UPDATE OF review ON hotels_reviews
BEGIN
  UPDATE hotels_reviews_index SET review = new.review WHERE rowid = old.id;
END;

-- Trigger on DELETE
CREATE TRIGGER after_hotels_reviews_delete AFTER DELETE ON hotels_reviews
BEGIN
  DELETE FROM hotels_reviews_index WHERE rowid = old.id;
END;

-- INSERTING DATA

-- After creating triggers, we can fill the table with reviews.
SELECT 'Inserting data...';

INSERT INTO hotels_reviews (review) VALUES
  ("Perfect position inside the souq, 5 minute by walk from Jemaa el fna square. Staff super kind, everyone very nice and always giving support and suggestions. Rooms clean and comfortable. Nice breakfast. Very good wifi. Everything was nice and satisfying our expectations. Thank you! Hope to come back again!!!"),
  ("Hussain was very helpful and saved us quite a bundle with his tips on haggling at the shops and other services.
The place was charming and tastefully decorated.
Location was ideal and in the middle of all the places we wanted to see."),
  ("The location was great for exploring. The Riad is just a 5 minute walk from Djema El Fnaa square and just off one of the main souk streets, souk semmarine. So we could just head out for a quick shop and with Cafe des Epices and Nomad (both great rooftop cafes/restaurants) less than a minute away there\'s great dining options too. The Riad itself has a lot of charm and the staff were lovely. Hussein and Assad welcomed us on the main square and showed us the way to the riad. They were always present and helpful throughout our stay and ready with local recommendations of things to to do and places to eat. Hussein also arranged a day trip to the Ourika valley and waterfalls for us. We stayed in Elf Lila Wa Lila suite. The room has a lovely decor which makes you feel like you are in 1001 nights. We had a safe in the room which was really helpful so that we didn\'t have to take our passports and spare money out with us. The towels were changed daily. Overall a great experience and we would definitely recommend this Riad."),
  ("The riad is small and quiet, with very comfortable beds.
Great location, only 3 mins. from Jamaa el Fna square and very safe area during the night, even though the street is a bit dark.
My suggestion is to book a taxi with them (15 Euros - 150 Dirhams) from the airport to the main square \(cars can\'t get in the medina as streets are too tight\).
From Jamaa el Fna either the driver or a member of the staff will lead you to the riad, as you will need to get through the market and at first sight looks like a labyrinth, is very crowded and confusing and you can get lost very easily.
Very nice members of the staff, they gave us a lot of advices and tips during our stay, always ready to help us and answer our questions. They even made us breakfast very early in the morning the day we left for our trip in the desert.
Delicious Moroccan breakfast freshly made every morning.
If I will ever go to Marrakech again, I would definitely get a room at this riad.
I highly recommend it."),
  ("The decor was lovely - our shower was like no other I\'ve ever seen. The breakfast yoghurt was great! The terrace had beautiful flowers and lanterns and manager was excellently helpful."),
  ("Very nice manager and Central Location! Highly recommend if you like to explore the center of Marrakesh"),
  ("Gorgeous living space, old and authentic. Very comfortable and spotlessly clean. The breakfast was fresh and the yogurt particularly nice. The staff were so sweet and very helpful."),
  ("Property is great and staff was very helpful with tips once we got there. Also, managed to get a home cooking class that was a highlight of our stay"),
  ("Outstanding service and advice from Hussein the manager. The room was out of the Arabian nights. The airport pick up and drop off perfect. We had a very nice but expensive meal first night at the Riad. __- a cancelled flight made this difficult but Hussein made it work. Location added to the entire experience"),
  ("We felt at home here! The hotel manager Hussein is really friendly and gave us some good recommendations/advice. Breakfast was delicious (and a lot!). Rooms were cleaned and beds made every day.")
;

-- QUERYING THE DATABASE
SELECT 'Retrieving data...';
SELECT '  ';

SELECT 'review:help';
SELECT '  ';

SELECT rowid, review
  FROM hotels_reviews_index
 WHERE hotels_reviews_index MATCH 'review:help';

-- We can also order by relevance which is the rank score:
SELECT '  ';
SELECT 'review:square AND location';
SELECT '  ';

  SELECT rowid, rank, review
    FROM hotels_reviews_index
   WHERE hotels_reviews_index MATCH 'review:square AND location'
ORDER BY rank;

-- Prefix and postfix search (wildcards)
SELECT '  ';
SELECT 'Prefix => review:com*';
SELECT '  ';

SELECT rowid, review
  FROM hotels_reviews_index
 WHERE hotels_reviews_index MATCH 'review:com*';

-- We can use some built-in functions
-- See documentation => https://www.sqlitetutorial.net/sqlite-full-text-search/
SELECT '  ';
SELECT 'Highlight => review:breakfast';
SELECT '  ';

  SELECT highlight(hotels_reviews_index, 0, '<b>', '</b>') review
    FROM hotels_reviews_index
   WHERE hotels_reviews_index MATCH 'review:breakfast'
ORDER BY rank;

SELECT '  ';
SELECT 'BM25 => review:help';
SELECT '  ';

  SELECT rowid, rank, review
    FROM hotels_reviews_index
   WHERE hotels_reviews_index MATCH 'review:square AND location'
ORDER BY bm25(hotels_reviews_index, 10.0);
