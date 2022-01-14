/*  postgres - Base Module: Create Schema DEVOPS, a workzone for developers and operations engineers. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create schema if not exists devops authorization %DBNAME%;

# Grant usage of devops schema to read and write roles:
grant usage on schema $schema to read, write;

# Grant read and write roles on devops tables:
grant insert, update, delete on all tables in schema devops to write;
grant select on all tables in schema devops to read;

# Grant read and write roles on devops sequences:
grant usage on all sequences in schema devops to write;
grant select on all sequences in schema devops to read;

# Grant execute to write roles on devops functions:
grant execute on all functions in schema devops to write;

# Revoke ALL on ALL TABLES in schema devops from public:
revoke all on all tables in schema devops from public;

# Revoke ALL on ALL SEQUENCES in schema devops from public:
revoke all on all sequences in schema devops from public;

# Revoke ALL on ALL FUNCTIONS in schema devops from public:
revoke all on all functions in schema devops from public;

comment on schema devops is 'Workzone for developers and operations engineers. All data in the devops, chief and other schemas are represented here, complete with names, descriptions and other useful associations. Views and materialized views provide the source data as required by developers and researchers. Views of source tables from the chief schema are updatable to allow safe data operations and to facilitate User Interface development.';
