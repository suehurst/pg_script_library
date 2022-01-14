/*  postgres - Base Module: Create view of Functions and their arguments in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_functions 
as
select pn.nspname     as function_schema
      ,pp.proname     as function_name
      ,pp.proargnames as function_arguments
      ,pd.description as function_description
	  ,(select pa.rolname 
		  from pg_catalog.pg_authid pa
		 where pa.oid = pn.nspowner
	   )              as "owner"      
  from pg_catalog.pg_proc pp
       left join pg_catalog.pg_description pd 
              on pd.objoid = pp.oid
       join pg_catalog.pg_namespace pn
	     on pn.oid = pp.pronamespace
        and pn.nspname not in ('dba','information_schema','pg_catalog','public')
;
comment on view devops.%DBNAME%_functions is 'Alias: FN - Master table of all functions and their arguments from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
