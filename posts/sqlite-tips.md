I've been playing around with SQLite recently and I've stumbled across a few things I want to remember, so I'm putting them here.

1.  The [SQLite CLI](https://sqlite.org/cli.html) is pretty darn good. Just remember to read in the SQLite DB file first, e.g. `.open /path/to/file`. After that, any SQLite command is valid. Specific CLI commands are prefixed with a period.

2.  Set the the `.mode` to `line` to visually grep the results.

3.  To see the `rowid` include it specifically in `SELECT` statements on the CLI, e.g. `SELECT rowid,* from table`.

4.  Delete an entry by `rowid` like this, `DELETE FROM table WHERE rowid=7;`

5.  When structuring a database, create a unique ID for each row like so: `create table foo (id INTEGER AUTO_INCREMENT PRIMARY KEY UNIQUE NOT NULL, other_column TEXT)`.

That's all I got for now. I'll drop more tips in this post as I come across them.
