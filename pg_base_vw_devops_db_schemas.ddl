/*  postgres - Base Module: Create view of production Schemas in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_schemas
as
select sch.schema_name             as schema_name
      ,sch.schema_owner            as schema_owner
      ,obj_description(pn.oid)     as schema_description	  
  from information_schema.schemata sch
       left join pg_catalog.pg_namespace pn 
	          on sch.schema_name = pn.nspname
 where sch.schema_name not in ('dba','information_schema','pg_catalog','public')
   and sch.schema_name not like 'pg_%'
;

comment on view devops.%DBNAME%_schemas is 'Alias: SCH - List of all productions schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
