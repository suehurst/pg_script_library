# PostgreSQL Script Library

Title: README.md\
Author: Susan Hurst\
Contact me: susan.hurst@brookhurstdata.com
Initial Creation: 2021-11-25\
Revision History:
| Version Number | Date | Editor | Description |
| -------------- | ---------- | ----------------- | -------------------------------------|
| 1.2 |   |   |   |
| 1.1 | 2021-12-30 | Susan Hurst | Finally added README.md and starter scripts. |
| 1.0 | 2021-11-25 | Susan Hurst | Initial Creation |

---

## Table of Contents
* [Overview](#overview)
* [Data Dictionary](#data-dictionary)
* [Schemas](#schemas)
* [Pre-conditions](#pre-conditions)
* [Modules](#modules)
* [Implementation Assumptions](#implementation-assumptions)
* [Implementation Steps](#implementation-steps)
* [Validations](#validations)


## Overview
The PostgreSQL Script Library is a companion to the book, [The Left Side of Monday](https://www.publishingconceptsllc.com/product/the-left-side-of-monday/). Specifically, the PostgreSQL Script Library illustrates the CLEAN (Consistent Live Enduring Accessible Navigable) data discussion in *The Data Factory* chapter.\
\
The scripts are organized by module, via the naming convention pg_admin_, pg_bar_, pg_base_ and pg_fdw_. The intent is to allow the database creator to choose which modules to install, except for the required Admin module. Other modules will be published at a later date. The **Admin** module is not optional. It contains the first steps for getting started, such as creating the database, a superuser and default roles and grants. The **BAR** (Backup-Audit-Recover) module answers the questions: who?, what?, where?, when? how? and how much?. As the name suggests, the BAR module monitors database activity for selected tables. The **Base** module includes a staging area for batch uploads of data, a storage area for protecting your single source of truth, a devops area that provides developers and users everything they need to do their jobs without contaminating the source data and a convenience store full of ready-to-use stored functions and procedures. The **FDW** module is a must for connecting to external data sources...just use those sources in situ (where they are).\
\
Basic functionality for building the foundation of your database is included in these scripts. Many functions and procedures are provided to limit the human error factor from contaminating your data asset. Even when errors occur, you can easily do root cause analysis to determine what went wrong so you can undo the error. Protections are built into the database objects themselves so that your database can defend itself.\
\
Use the principles for building the new foundation of your database as you develop new database objects specific to your business.

## Data Dictionary
Standard abbreviations and naming conventions are used throughout all script names and script contents.
| Name | Definition | Additional Notes |
| -------------- | --------------------------------------------------- | --------------------------------------------|
| abbr | Abbreviation | Short name value for an entity. |
| bar | Backup-Audit-Recover | Name of schema that manages the BAR (Backup-Audit-Recovery) process. Database objects using `bar` in object names and aliases are required for building the BAR process. See full description of BAR module in the Modules section. |
| base | Base | Database objects using `base` in object names are foundational objects upon which other objects are built. See full description of Base module in the Modules section. |
| bk | Business Key | One or more column values that together identify a unique row in a database table. Also known as an alternate key. |
| chief | Chief | Name of schema optimized for source data storage, not for data presentation. | 
| db | Database | The scripts names that have `db` in the name are for creating views in the Devops schema for the purpose of validating and documenting the database objects. These scripts have variables named %DBNAME% that must be replaced with the name of the database. |
| ddl | Data Definition Language | SQL syntax used for creating, modifying or deleting database objects. |
| devops | Development and Operations | Name of schema that contains functions and updatable views for presenting data to User. The is the Information Store. The goal of this schema is to provide all data needed by developers and operations engineers to do their jobs without touching the source data directly. |
| dml | Data Manipulation Language | SQL syntax used for select, insert, update or delete statements. |
| dom | Domain | Domain objects are defined to standardize the data types for commonly used columns, such as primary keys, names and dates. |
| dttz | Timestamp with time zone. | UTC (Coordinated Universal Time) timestamp appended with the number of hours removed from Greenwich Mean Time `+00`. Example: `2021-11-25 00:00:00-06` where `-06` indicates 6 hours behind UTC, or 'US/Central' time. In this example UTC time would be `2021-11-25 06:00:00+00`. |
| ext | Extension | PostgreSQL extensions that add specific functionality to the database management system. |
| fdw | Foreign Data Wrapper | Library that can communicate with an external data source, hiding the details of connecting to the data source and obtaining data from it. See a full description of the FDW module in the Modules section. |
| fk | Foreign Key | Foreign key generated within the host database to facilitate referential integrity. The Foreign Key points to a unique key in a parent table that must exist before it can be referenced in a child table. |
| fn | Function | Database object that performs tasks defined in its stored code then returns a value. Input parameters may specify the value to be returned. |
| id | Identifier | Identifier generated within the host database. |
| ident | Foreign Identifier | Identifier generated by a system or database external to the host database. Use for reference only. | 
| iur | Instead of Update Row | Naming convention for use in a trigger name to indicate a trigger that safely updates a row in a view instead of a source table directly. | 
| lcat | Lookup Categories | Master table for categorizing lookup data into specific business functions. A category is equivalent to the name of a lookup table. |
| ldat | Lookup Data | Lookup data elements for each Lookup Category. Data elements for each Lookup Category are equivalent to rows in a lookup table. |
| pk | Primary Key | Unique identifier for a row in a database table, typically of the data type: UUID (Universally Unique Identifier). |
| prc | Procedure | Database object that performs tasks defined in its stored code. Input parameters may specify the tasks to be performed. |
| sch | Schema | Database structure that contains database objects (tables, functions, etc) related to a defined type of data to be used for a specific purpose. For example, the schema `stg` is used for storing staging tables and functions for the purpose of accepting raw data from an external source and preparing the data for insertion into production tables in other schemas of the host database. |
| sql | Structured Query Language | A sentence structure that uses specific syntax to ask the database to return data as requested. |
| std | Standard |  |
| stg | Stage or Staging | Name of schema used specifically for storing staging tables and functions for the purpose of accepting raw data from an external source and preparing the data for insertion into production tables in other schemas of the host database. |
| store | Store | Name of schema for warehousing commonly used stored functions and procedures that may be called from any schema in the database. |
| tbl | Table | Database table with columns of metadata (data about data) and rows of data (actual values). |
| trg | Trigger | Any event that sets a course of action in a motion. A trigger database object defines the course of action as well as the event that causes the trigger to fire, such as modifying a row in a table. |
| UUID | Universally Unique Identifier | A 128-bit label used for creating a unique value, such as for a primary key. |
| v_ | Virtual | Naming convention used for designating a virtual column to ensure uniqueness of the companion. It compares the lower case version and digits of the value without spaces or special characters to any other values that may already exist. Virtual columns are used in Business Keys. |
| virtual_string() | Virtual String Function | Function that removes diacritics, white spaces and non-alphanumeric characters then returns the lower case version of a string. This function is used for creating virtual columns and unique Business Keys. | 
| vw | View | Database view of one or more database tables. A view is a stored SQL query. |

## Schemas
Schemas must be created before creating other database objects. Each module will install the schemas required for that module. Here are descriptions of the schemas included in the BAR and Base modules. Note: The public schema is not used for any database objects as a security precaution. Grants are specifically revoked from public to the database objects in the schemas listed below. Public must still be available to users, however, for access to pg_catalog and to information schema.
| Schema Name | Description |
| ----------- | --------------------------------------------- |
| bar | Habitat for Backup-Audit-Recover (BAR) processes and data. All insert, update and delete activity lives here for selected tables participating in the BAR (Backup-Audit-Recovery) process. SQL queries that generated the data reside here as well for the purpose of auditing and/or recovering data that were changed. |
| chief | Master habitat for storing and protecting source data and data associations. The chief schema provides data to views in the devops and other schemas but is not intended to be a workzone itself. Rather, the purpose of the chief schema is to protect a single source of truth for each entity that resides there. |
| devops | Workzone for developers, operations engineers and users. All data in the bar, chief and other schemas are represented here, complete with names, descriptions and other useful associations. Views and materialized views provide the source data as required by developers and researchers. Views of source tables from the chief schema are updatable to allow safe data operations and to facilitate User Interface development. Views typically join 2 or more tables together so that users can see human readable values for foreign keys instead of identifiers. |
| stg | Staging area for batch loading external data into source tables. The stg schema includes staging tables as well as functions to properly load data into source tables in the chief schema. A load reject log table provides feedback about individual items that could not be loaded. |
| store | Habitat for stored procedures and functions that perform tasks consistently and reliably. The inventory of functions includes utility tasks for getting commonly used values as well as supporting functions for standardizing the structures of database objects. |

## Pre-Conditions
- PostgreSQL version 12 or higher must be installed. This version is required for creating virtual columns in the table definitions. Virtual columns are used for creating unique Business Keys.
 Example: `,v_name            text generated always as (store.virtual_string(name)) stored`
- Password file `.pgpass` must already exist in location designated for your PostgreSQL installation.
- Password file `.pgpass` must contain the `host:port:db_name:user_name:password` for the new host database.
- Variables, enclosed in %%, must be replaced with the desired values in some scripts. If possible, use an external script for this task or use a Find and Replace tool that can replace values in all scripts. Variables that need values are:
    * %DBNAME%: Name of the host database. All modules and validations.
    * %HOSTNAME%: Host name or IP address of the host database server. All modules.
    * %FDW_HANDLER%: Foreign Data Wrapper file handler. Example: `postgres_fdw`. FDW module.
    * %SERVERNAME%: Name of the foreign server as it will appear in the host database. FDW module.
    * %FOREIGNHOST%: Host name or IP address where foreign database lives. FDW module.
    * %FOREIGNPORT%: Port for foreign database on the foreign server.  FDW module.
    * %FOREIGNDBNAME%: Name of foreign database. FDW module.
    * %PASSW%: Password to foreign database. FDW module.
    
## Modules
Modules are logical groupings of scripts that are intended to produce specific functionality.  For example, the BAR module only executes installation scripts for BAR functionality and nothing else. The Admin module is required but all other modules are optional, however BAR and Base are strongly recommended.

- **Admin**
The Admin module must be installed first, as this is the seed for all other modules. Admin creates these objects:
    * Superuser: The database name is used for the superuser name.
    * Database: The database itself is created, after the superuser has been created.
    * Admin Login Role: ${DBNAME}_admin is a login role for actively modifying data, but is not a superuser. The role can be used in external scripts and User Interfaces.
    * User Login Role: ${DBNAME}_user is a login role for reading data. The role can be used in external scripts and User Interfaces.
    * Group Role - Read: Role to be assigned to all users.
    * Group Role - Write: Role to be assigned to users who need read, create, update and delete privileges.
    * Grants of Group Roles to Login Roles. Each schema installation will assign grants to the Read and Write roles for its objects.
    * Grants select on tables in the public schema to the login roles. This allows all users to read any query results from the information schema or from pg_catalog, such as the views created in the devops schema for describing the database objects installed for the host database.

- **BAR**  
The Backup-Audit-Recover module consists of 3 tables plus 2 functions and 2 procedures to capture inserts, updates, deletes and truncates in selected production tables, usually in the chief schema. Typically, the selected tables acquire data and modifications from users (humans), thus the need for auditing. Tables that are always loaded by an automated process may not need to be audited. Audit data include details about the user and the DML, including the actual SQL statement that was used.
\
The 3 tables are:
    * `bar.captured_dml_data` (actual rows that were modified and DML type)
    * `bar.captured_dml_events` (user audit info and query that was executed)
    * `bar.captured_tables` (list of tables participating in BAR)\
\
In order to populate bar.captured tables, the bar.install procedure must be called. Example: `call bar.install('chief'::text,'lookup_categories'::text);`. Because this procedure creates 4 triggers on the named table, it must be called by an administrator or user with create privileges.\
\
Views are created in the devops schema for the 3 tables so that users have a friendly view of the audit data without the need to join tables together.

- **Base**
The Base module installs database objects that are the foundation of the host database:
    * Staging area for batch loading external data into the host database.
    * Safe storage area for production tables containing source data. Foundation for your single source of truth. It also provides a repository for lookup data that provisions drop-down lists in user interfaces, which preserves the geneaology of data that use lookup values.
    * Workzone for developers, operations engineers and users.
    * Convenience store for pre-built functions and procedures.
    
- **FDW**
With the Foreign Data Wrapper module, your host database can set up a connection directly to one or more other external databases, including NoSQL databases. Each database management system requires its own handler. For more information about Foreign Data Wrappers see: [Foreign Data Wrappers](https://wiki.postgresql.org/wiki/Foreign_data_wrappers).
\
Pre-condition: **Base** module must be installed before installing **FDW** module.
Pre-condition: Each connection to a foreign database must be declared in `pg_hba.conf`:\
    **#**TYPE  DATABASE        USER            ADDRESS                 METHOD\
    host	%FOREIGNDBNAME	%DBNAME%	%FOREIGNHOST%	%PASSW%
\
The setup script provided in this module `pg_fdw_fdw_setup.ddl` includes:
    * Extension: Must be the proper extension for the external database management system. For example, connecting to another PostgreSQL database would require the `postgres_fdw` extension.
    * Foreign Data Wrapper: Typically, the same name as the extension.
    * Server: Defines the host, port and the name of the external database as it is known on that host/port. Name the server something that helps identify the external source. For example, connecting to a foreign database named geo could be named geoserver. 
    * User Mappings: Defines which users can read or modify data from an external database.
    * Grants define the privileges for each user mapping.
    * Comment to describe the foreign data wrapper.

## Implementation Assumptions
- Database creator does not have any external scripts to execute the DDL scripts.
- Database creator uses an IDE (Integrated Development Environment) such as PGAdmin, DBeaver, SQL Developer, etc., to execute DDL scripts.
- Although not required, database creator is encouraged to create install scripts, using shell scripts, Python, PHP or any other scripting language. Use the [Implementation Steps] as pseudocode.
- Modules are installed in order of operations dependencies: Admin -> BAR -> Base -> FDW.

## Implementation Steps
- **Admin**
1. Connect to your database server as superuser postgres.
2. Execute: `pg_admin_db.ddl`.
3. Connect to your database server as the new superuser you just created named with the same name as the new host database. This will ensure that all database objects that are installed in the remaining Implementation Steps belong to the database/superuser and not to postgres.
4. Execute: `pg_admin_roles_grants.ddl`.
- **BAR**
1. Create Extensions: `pg_bar_ext_extensions.ddl`
2. Create Schemas: `pg_bar_sch_bar.ddl`
3. Create Gen ID Function before installing tables: `pg_bar_fn_bar_gen_id.ddl`
4. Create Tables: 
    * `pg_bar_tbl_bar_captured_dml_data.ddl`
    * `pg_bar_tbl_bar_captured_dml_events.ddl`
    * `pg_bar_tbl_bar_captured_tables.ddl`
5. Create Function: `pg_bar_fn_bar_dml_capture.ddl`
6. Create Procedures: 
    * `pg_bar_prc_bar_install.ddl`
    * `pg_bar_prc_bar_install_overload.ddl`
7. Create Views:
    * `pg_bar_vw_devops_bar_captured_dml_data.ddl`
    * `pg_bar_vw_devops_bar_captured_dml_events.ddl`
    * `pg_bar_vw_devops_bar_captured_tables.ddl`
8. Create Foreign Keys:
    * `pg_bar_fk_bard2bare_fk.ddl`
    * `pg_bar_fk_bare2bart_fk.ddl`
- **Base**
1. Create Extensions: `pg_base_ext_extensions.ddl`
2. Create Schemas: 
    * `pg_base_sch_chief.ddl`
    * `pg_base_sch_devops.ddl`
    * `pg_base_sch_stg.ddl`
    * `pg_base_sch_store.ddl`
3. Create Domains: 
    * `pg_base_dom_chief_std_abbr.ddl`
    * `pg_base_dom_chief_std_create_dttz.ddl`
    * `pg_base_dom_chief_std_date.ddl`
    * `pg_base_dom_chief_std_description.ddl`
    * `pg_base_dom_chief_std_end_dttz.ddl`
    * `pg_base_dom_chief_std_foreign_ident.ddl`
    * `pg_base_dom_chief_std_foreign_name.ddl`
    * `pg_base_dom_chief_std_id.ddl`
    * `pg_base_dom_chief_std_name.ddl`
    * `pg_base_dom_chief_std_pk.ddl`
4. Create types:
    * `pg_base_typ_chief_column_def_struct.ddl`
    * `pg_base_typ_chief_table_name_struct.ddl`
5. Create Virtual String Function before creating tables: `pg_base_fn_store_virtual_string.ddl`
6. Create Tables:
    * `pg_base_tbl_chief_lookup_categories.ddl`
    * `pg_base_tbl_chief_lookup_data.ddl`
    * `pg_base_tbl_chief_sources.ddl`
    * `pg_base_tbl_stg_load_reject_log.ddl`
    * `pg_base_tbl_stg_lookup.ddl`
    * `pg_base_tbl_stg_sources.ddl`
7. Create Functions:
    * `pg_base_fn_devops_invalid_col_update.ddl`
    * `pg_base_fn_devops_lookup_update.ddl`
    * `pg_base_fn_devops_sources_update.ddl`
    * `pg_base_fn_stg_gen_load_reject_message.ddl`
    * `pg_base_fn_stg_migrate_lookups.ddl`
    * `pg_base_fn_stg_migrate_sources.ddl`
    * `pg_base_fn_store_create_lookup.ddl`
    * `pg_base_fn_store_create_source.ddl`
    * `pg_base_fn_store_current_function.ddl`
    * `pg_base_fn_store_lcat_id.ddl`
    * `pg_base_fn_store_ldat_id.ddl`
    * `pg_base_fn_store_src_id.ddl`
8. Create Views:
    * `pg_base_vw_devops_db_business_keys.ddl`
    * `pg_base_vw_devops_db_domains.ddl`
    * `pg_base_vw_devops_db_foreign_keys.ddl`
    * `pg_base_vw_devops_db_functions.ddl`
    * `pg_base_vw_devops_db_objects.ddl`
    * `pg_base_vw_devops_db_primary_keys.ddl`
    * `pg_base_vw_devops_db_schemas.ddl`
    * `pg_base_vw_devops_db_tables_columns.ddl`
    * `pg_base_vw_devops_db_triggers.ddl`
    * `pg_base_vw_devops_db_types.ddl`
    * `pg_base_vw_devops_db_views.ddl`
    * `pg_base_vw_devops_load_reject_log.ddl`
    * `pg_base_vw_devops_lookup.ddl`
    * `pg_base_vw_devops_sources.ddl`
9. Create Triggers:
    * `pg_base_trg_lookup_iur_trg.ddl`
    * `pg_base_trg_sources_iur_trg.ddl`
10. Add tables in chief schema to BAR process: `pg_base_bar_install.ddl` 
    * For each Foreign Data Wrapper: `pg_fdw_fdw_setup.ddl`

## Validations
Login to the newly created database as any authorized user with read privileges, at minimum.
- **Option 1:**\
Execute a separate SQL script for each database object type that was created by the database owner. Built-in PostgreSQL objects are excluded from the output. Compare the output with the DDL scripts listed in the **Implementation Steps** for each object type. All installed modules are included in the output.
SQL Scripts:
    * `valid_01_database.sql`
    * `valid_02_schemas.sql`
    * `valid_03_domains.sql`
    * `valid_04_fdws_fservers.sql`
    * `valid_05_tables.sql`
    * `valid_06_functions.sql`
    * `valid_07_views.sql`
    * `valid_08_foreign_keys.sql`
    * `valid_09_triggers.sql`
    * `valid_10_types.sql`
    * `valid_11_missing_comments.sql`
    
- **Option 2:**\
Execute a single SQL script to show all of the objects that were created by the database owner. Built-in PostgreSQL objects are excluded from the output. Compare the output with the DDL scripts listed in the **Implementation Steps**. All installed modules are included in the output.\
Note: The output is quite large and may be difficult to use for comparison to the **Implementation Steps**.
    * SQL Script: `valid_13_installed_objects.sql`
