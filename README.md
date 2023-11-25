# postgres-docker-compose

Docker compose setup for postgres@latest (as of November 2023 this
is 16.1).  Choose the version you want to test by setting up an
approprite env value in .env file

The first time you bring up the container postgres will initialise
the db data folder and this will persist as a local folder when
you down the containers.  If you want to test with a different
postgres version you need to remove the files/folders in ./data/db
A make recipe - make reset - has been provided for this.

Also note that the data directory has been specifically excluded
from the git repo.  Doing a - make setup - will create these paths
if they do not already exist.

# Overview

Checkout the Makefile.  Run 'make setup' to create the required docker network

Update the .env file to set the ports you want to use to expose the DB and
adminer on localhost.  Also the database password.

Once you have done that you can bring the database container up.

# ./data and ./storage

Local directories are mapped into the running docker container
to allow you to copy data in and out or backup your database
if you customize it.

If you - make bash - into the DB container and then 'cd ~' you
will end up in /root which will be exposed locally as data/root.

So you could for instance:

```
make su-postgres
pg_dump postgres > /bak/postgres.sql
```

This would make the postgres.sql DB dump visible as ./data/bak/postgres.sql


## Bringing the Container(s) Up

This brings up an adminer container up alongside the database which
you can reach via http://localhost:80xx where 80xx is the port you
set in the .env file

```
make up
```

To Shut the Container(s) Down


Run this make command.

```
make down
```



# Links

* https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/


# Connect to Database Instance via Exposed localhost Port

```
% psql -h localhost -p 5434 -Upostgres
Password for user postgres: 
psql (14.9 (Homebrew), server 13.13 (Debian 13.13-1.pgdg120+1))
Type "help" for help.

postgres=# \l
List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

Now using Makefile recipe 'connect'

```
 % make connect
Password is secret
PGPASSWORD=secret psql -h localhost -p 5434 -Upostgres
psql (14.9 (Homebrew), server 13.13 (Debian 13.13-1.pgdg120+1))
Type "help" for help.

postgres=# 
```

