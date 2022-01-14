/*  postgres - Base Module: Create Schema CHIEF for production data storage...single source of truth. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create schema if not exists chief authorization %DBNAME%;

# Grant usage of chief schema to read and write roles:
grant usage on schema $schema to read, write;

# Grant read and write roles on chief tables:
grant insert, update, delete on all tables in schema chief to write;
grant select on all tables in schema chief to read;

# Grant read and write roles on chief sequences:
grant usage on all sequences in schema chief to write;
grant select on all sequences in schema chief to read;

# Grant execute to write roles on chief functions:
grant execute on all functions in schema chief to write;

# Revoke ALL on ALL TABLES in schema chief from public:
revoke all on all tables in schema chief from public;

# Revoke ALL on ALL SEQUENCES in schema chief from public:
revoke all on all sequences in schema chief from public;

# Revoke ALL on ALL FUNCTIONS in schema chief from public:
revoke all on all functions in schema chief from public;

comment on schema chief is 'Master habitat for storing and protecting source data and data associations. The chief schema provides data to views in the devops and other schemas but is not intended to be a workzone itself. Rather, the purpose of the chief schema is to protect a single source of truth for each entity that resides there.';
