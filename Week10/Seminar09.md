## Seminar 09 - NoSQL Databases (part 2)

In this seminar, we will play with [Neo4j Aura DB](https://neo4j.com/cloud/aura/?ref=neo4j-home-hero), a **graph** database.

### Activity 1 - Setting up your AuraDB account

* Go to the [Neo4j Aura DB](https://neo4j.com/cloud/aura/?ref=neo4j-home-hero) webpage and choose `Start Free`.
* Create an user or log in with an existing one.
* Pick the `AuraDB Free` database option, choose a database name (e.g. `ST207_yourname`) and the `MOVIE` database as your starting database.
* **IMPORTANT**: make sure to write down the username (`neo4j`) and the generated password. Copy this information to your local computer and make sure it is handy (you will need this to connect to the Neo4j server).
* Go to the dashboard and choose `Learn to use Neo4j`.
* Finally, on your dashboard, choose `Open with Neo4j Browser`.

### Activity 2 (tutorial) - Cypher language

We will go through the **Cypher language** tutorial over the `aura/movie` database.

On the bottom left of your browser, follow **steps 1 to 11** to an introduction to the Cypher language. Pay special attention to all concepts and the syntax.

### Activity 3 (tutorial / self-study) - Relational to graph database

We will explore the `Northwind Graph Guide` for a demonstration on how we can migrate a relational database into Neo4j.

On the top left of your browser, click on **Neo4j Browser guides** and choose the `guide: northwind-graph`. Follow the steps.

### Activity 4 (homework / self-study) - Create your own Neo4j database

You can play with the browser version (AuraDB) or [download a desktop version](https://neo4j.com/download-neo4j-now).

**IMPORTANT**: the AuraDB free tier allows only one free database. If you have used the `aura/movie` example, you cannot create a second database, unless your remove the example project. You can use the **Neo4j Desktop** version for that. Alternatively, you can keep using the example project (`aura/movie` database) and create or import any additional file into this project.

Have a look at **Moodle**. There are some additional materials on modelling and Cypher that you can use as reference. Also, get some **example datasets** from the `data` folder on GitHub.

### References

- [Neo4j WHERE operators](https://neo4j.com/docs/cypher-manual/4.1/clauses/where/).
- [Connection to AuraDB through Cypher shell](https://neo4j.com/developer/aura-connect-cypher-shell/)
- [Several graph examples](https://neo4j.com/graphgists/).
- [Neo4j Graph databases](https://github.com/iansrobinson/graph-databases-use-cases) - code examples from the book.
