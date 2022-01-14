/*  postgres - Base Module: Create view of Domains in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_domains 
as
select pn.nspname                               as domain_schema
      ,pt.typname                               as domain_name
      ,format_type(pt.typbasetype,pt.typtypmod) as data_type
      ,pt.typdefault                            as default_value
      ,obj_description(pt.oid)                  as domain_description
      ,(not pt.typnotnull)                      as is_nullable
	  ,(select pa.rolname 
		  from pg_catalog.pg_authid pa
		 where pa.oid = pn.nspowner
	   )                                        as "owner"      
  from (pg_type pt
       left join pg_catalog.pg_namespace pn 
              on (pn.oid = pt.typnamespace)
       )
 where (   pt.typtype = 'd'::"char" 
       and pn.nspname not in ('dba','information_schema','pg_catalog','public')
       )
;

comment on view devops.%DBNAME%_domains is 'Alias: DOM - Master list of Domains in the %DBNAME% schema and their descriptions from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';

