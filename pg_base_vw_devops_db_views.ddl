/*  postgres - Base Module: Create view of Views in the devops schema. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_views 
as
select pn.nspname                                        as view_schema
      ,c.table_name                                      as view_name
      ,split_part(obj_description(pc.oid), ' '::text, 2) as view_alias
      ,obj_description(pc.oid)                           as view_description
      ,c.column_name                                     as view_column_name
	  ,c.is_updatable                                    as is_updatable
	  ,pa.rolname                                        as "owner"
  from information_schema.columns  c
       join pg_catalog.pg_class    pc
	     on pc.relname = c.table_name::name
		and pc.relkind = 'v'::"char"  
	   join pg_catalog.pg_namespace     pn
	     on pc.relnamespace = pn.oid
        and pn.nspname not in ('dba','information_schema','pg_catalog','public')
	   join pg_catalog.pg_authid   pa
	     on pn.nspowner = pa.oid
;

comment on view devops.%DBNAME%_views is 'Alias: VW - List of all devops views, columns and their descriptions in the devops schema.';
