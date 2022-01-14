/*  postgres - Base Module: Create view of user defined Types in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_types 
as
select distinct 
       pn.nspname                 as type_schema
      ,pt.typname                 as type_name
      ,obj_description(pt.oid)    as type_description
	  ,(select rolname 
		  from pg_catalog.pg_authid 
		 where oid = pn.nspowner
	   )                          as "owner"    	  
  from pg_catalog.pg_class   pg 
      ,pg_catalog.pg_type    pt
       left join pg_catalog.pg_namespace pn 
              on pn.oid = pt.typnamespace
			 and pn.nspname not in ('dba','information_schema','pg_catalog','public')
			 and pn.nspname not like 'pg_%'
			 and pt.typbasetype = 0
			 and pt.typtype = 'c'
 where pg.relkind = 'c'
   and pt.typowner = pn.nspowner
   and pt.typname not in (select table_name from information_schema.tables)
;

comment on view devops.%DBNAME%_types is 'Alias: TYP - List of user defined types (excluding domains) and their descriptions from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
