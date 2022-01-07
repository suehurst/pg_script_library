/*  postgres - Base Module: Create Schema STORE, an inventory of procedures and functions that perform tasks consistently and reliably. 
    A %PLACEHOLDER% expects a DB name to be provided. - ddl  
*/

create schema if not exists store authorization %DBNAME%;

# Grant usage of store schema to read and write roles:
grant usage on schema $schema to read, write;

# Grant read and write roles on store tables:
grant insert, update, delete on all tables in schema store to write;
grant select on all tables in schema store to read;

# Grant read and write roles on store sequences:
grant usage on all sequences in schema store to write;
grant select on all sequences in schema store to read;

# Grant execute to write roles on store functions:
grant execute on all functions in schema store to write;

# Revoke ALL on ALL TABLES in schema store from public:
revoke all on all tables in schema store from public;

# Revoke ALL on ALL SEQUENCES in schema store from public:
revoke all on all sequences in schema store from public;

# Revoke ALL on ALL FUNCTIONS in schema store from public:
revoke all on all functions in schema store from public;

comment on schema store is 'Habitat for stored procedures and functions that perform tasks consistently and reliably. The inventory of functions includes utility tasks for getting commonly used values as well as supporting functions for standardizing the structures of database objects.';

