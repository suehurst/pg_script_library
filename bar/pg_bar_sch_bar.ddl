/*  postgres - BAR Module: Create Schema for BAR (Backup-Audit-Recovery) processes. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

# create the schema
create schema if not exists bar authorization %DBNAME%;

# Grant usage of bar schema to read and write roles:
grant usage on schema $schema to read, write;

# Grant read and write roles on bar tables:
grant insert, update, delete on all tables in schema bar to write;
grant select on all tables in schema bar to read;

# Grant read and write roles on bar sequences:
grant usage on all sequences in schema bar to write;
grant select on all sequences in schema bar to read;

# Grant execute to write roles on bar functions:
grant execute on all functions in schema bar to write;

# Revoke ALL on ALL TABLES in schema bar from public:
revoke all on all tables in schema bar from public;

# Revoke ALL on ALL SEQUENCES in schema bar from public:
revoke all on all sequences in schema bar from public;

# Revoke ALL on ALL FUNCTIONS in schema bar from public:
revoke all on all functions in schema bar from public;

comment on schema bar is 'Habitat for Backup-Audit-Recover (BAR) processes and data. All insert, update and delete activity lives here for selected tables participating in the BAR (Backup-Audit-Recovery) process. SQL queries that generated the data reside here as well for the purpose of auditing and/or recovering data that were changed.';

