/*  postgres - Base Module: Create view of Foreign Keys in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_foreign_keys
as
select tc.table_schema    as table_schema
      ,tc.constraint_name as foreign_key_name
      ,tc.table_name      as table_name
      ,array_agg(distinct kcu.column_name)  as column_name
      ,ccu.table_schema   as foreign_table_schema
      ,ccu.table_name     as foreign_table_name
      ,array_agg(distinct ccu.column_name)  as foreign_column_name
      ,pd.description     as foreign_key_description
  from information_schema.table_constraints tc
       left join ( select d.description
                         ,pcon.conname
                     from pg_description d
                         ,pg_class pc
                         ,pg_constraint pcon
                    where d.classoid = pc.relfilenode 
                      and pcon.contype = 'f'::"char" 
                      and pc.relname = 'pg_constraint'::name 
                      and d.objoid = pcon.oid
                 ) pd 
              on pd.conname = tc.constraint_name::name
       join information_schema.key_column_usage kcu
	     on tc.constraint_name = kcu.constraint_name 
        and tc.table_schema = kcu.table_schema
       join information_schema.constraint_column_usage ccu
	     on ccu.constraint_name = tc.constraint_name 
        and ccu.table_schema = tc.table_schema 
        and tc.constraint_type = 'FOREIGN KEY' 
        and tc.table_schema not in ('dba','information_schema','pg_catalog','public')
 group by tc.table_schema
         ,tc.constraint_name
		 ,tc.table_name
		 ,ccu.table_schema
		 ,ccu.table_name
		 ,pd.description
;

comment on view devops.%DBNAME%_foreign_keys is 'Alias: FK - List of Foreign Key constraints including key table/column, foreign table/column and their descriptions from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
