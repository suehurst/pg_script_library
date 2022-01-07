/*  postgres - Base Module: Create Schema STG, a staging area for preparing and batchloading data from external sources into production tables. 
    A %PLACEHOLDER% expects a DB name to be provided. - ddl  
*/

create schema if not exists stg authorization %DBNAME%;

# Grant usage of stg schema to read and write roles:
grant usage on schema $schema to read, write;

# Grant read and write roles on stg tables:
grant insert, update, delete on all tables in schema stg to write;
grant select on all tables in schema stg to read;

# Grant read and write roles on stg sequences:
grant usage on all sequences in schema stg to write;
grant select on all sequences in schema stg to read;

# Grant execute to write roles on stg functions:
grant execute on all functions in schema stg to write;

# Revoke ALL on ALL TABLES in schema stg from public:
revoke all on all tables in schema stg from public;

# Revoke ALL on ALL SEQUENCES in schema stg from public:
revoke all on all sequences in schema stg from public;

# Revoke ALL on ALL FUNCTIONS in schema stg from public:
revoke all on all functions in schema stg from public;

comment on schema stg is 'Staging area for batch loading external data into source tables. The stg schema includes staging tables as well as functions to properly load data into source tables in the chief schema. A load reject log table provides feedback about individual items that could not be loaded.';
