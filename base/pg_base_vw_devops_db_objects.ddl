/*  postgres - Base Module: Create view of Objects in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_objects 
as
select pn.nspname                  as object_schema
      ,pc.relname                  as object_name
      ,case pc.relkind
            when 'r'::"char" then 'table'::text
            when 'm'::"char" then 'materialized view'::text
            when 'i'::"char" then 'index'::text
            when 's'::"char" then 'sequence'::text
            when 'v'::"char" then 'view'::text
            when 'c'::"char" then 'type'::text
            when 'f'::"char" then 'foreign table'::text
            when 't'::"char" then 'toast table'::text
       else 
            pc.relkind::text
       end                         as object_type
      ,pa.rolname                  as object_owner
  from pg_catalog.pg_class pc
       join pg_catalog.pg_authid  pa
         on pa.oid = pc.relowner 
       join pg_catalog.pg_namespace pn
         on pn.oid = pc.relnamespace
        and pn.nspname not in ('dba','information_schema','pg_catalog','public')
        and pn.nspname !~~ 'pg_toast%'::text
union
select pn.nspname                  as object_schema
      ,pp.proname                  as object_name
      ,'function'::text            as object_type
      ,pa.rolname                  as object_owner
  from pg_catalog.pg_proc pp
       join pg_catalog.pg_authid pa
         on pp.proowner = pa.oid
       join pg_catalog.pg_namespace pn
         on pp.pronamespace = pn.oid
        and pn.nspname not in ('dba','information_schema','pg_catalog','public')
;

comment on view devops.%DBNAME%_objects is 'Alias: OBJ - Master table of all database objects from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public'' and their owners (all should be owned by the target database).';
