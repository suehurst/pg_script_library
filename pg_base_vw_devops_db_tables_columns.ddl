/*  postgres - Base Module: Create view of production Tables and Columns in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_tables_columns 
as
select t.table_schema                                     as table_schema
      ,t.table_name                                       as table_name
      ,replace((pc.conname),'_pk','_id')                  as primary_key
      ,replace((pc.conname)::text, '_pk'::text, ''::text) as table_alias
      ,pdt.description                                    as table_description
	  ,(select distinct 
		       pa.rolname 
		  from pg_catalog.pg_authid  pa
		      ,pg_catalog.pg_tables  pt
		 where pa.rolname = pt.tableowner
		   and pt.tablename = t.table_name
	   )                                                  as "owner"        
      ,c.column_name                                      as column_name
      ,case
       when c.domain_name is null
       then
            case
            when (c.data_type::text ~~ 'character%'::text) 
            then 
                 (((c.data_type::text || ' ('::text) || c.character_maximum_length) || ')'::text)::character varying
            else (c.data_type)::character varying
            end
       else 
            (coalesce(c.domain_name, c.udt_name))::character varying
       end                                                as data_type
      ,c.column_default                                   as column_default
      ,pdc.description                                    as column_description
      ,c.is_nullable                                      as is_nullable
  from information_schema.tables t
       join pg_catalog.pg_statio_all_tables st 
         on t.table_name::name = st.relname
        and t.table_schema::name = st.schemaname 
        and t.table_schema::text not in ('dba','information_schema','pg_catalog','public')
        and t.table_type = 'BASE TABLE'
       join information_schema.columns c 
         on (c.table_schema::name = st.schemaname 
            and c.table_name::name = st.relname
            )
            left join pg_constraint pc 
                   on (pc.conrelid = st.relid 
                      and (pc.contype = 'p'::"char")
                      )
            left join pg_description pdc 
                   on pdc.objoid = st.relid 
                  and pdc.objsubid = c.ordinal_position::integer
                  and pdc.classoid = (select pg_class.oid
                                        from pg_class
                                       where pg_class.relname = 'pg_class'::name
                                     ) 
                  and pdc.objsubid <> 0
            left join pg_description pdt 
                   on pdt.objoid = st.relid
                      and (pdt.classoid = (select pg_class.oid
                                             from pg_class
                                            where pg_class.relname = 'pg_class'::name 
                                              and pdt.objsubid = 0
                                          )
                          )
;

comment on view devops.%DBNAME%_tables_columns is 'Alias: TC - List of all production tables, columns and their descriptions from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
