/*  postgres - Admin Module: Create a superuser, using the database name, then create the database. - ddl  */

# create a superuser role for the new database
create role ${DBNAME} login superuser inherit createdb createrole replication;

# create the database
create database ${DBNAME} with owner = ${DBNAME};
