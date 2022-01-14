/*  postgres - Base Module: Create view of Primary Keys in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_primary_keys 
as
select tc.table_schema    as table_schema
      ,tc.constraint_name as primary_key_name
      ,tc.table_name      as table_name
      ,array_agg(distinct kcu.column_name)  as column_name
      ,'Table name: '||tc.table_name||'  -  Primary Key column: '||array_agg(distinct kcu.column_name)::text  as primary_key_description
  from information_schema.table_constraints tc
       join information_schema.key_column_usage kcu
	     on tc.constraint_name = kcu.constraint_name 
        and tc.table_schema = kcu.table_schema
       join information_schema.constraint_column_usage ccu
	     on ccu.constraint_name = tc.constraint_name 
        and ccu.table_schema = tc.table_schema 
        and tc.constraint_type = 'PRIMARY KEY' 
        and tc.table_schema not in ('dba','information_schema','pg_catalog','public')
 group by tc.table_schema
         ,tc.constraint_name
		 ,tc.table_name
;  

comment on view devops.%DBNAME%_primary_keys is 'Alias: PK - List of Primary Key constraints including key table/column and their descriptions from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
