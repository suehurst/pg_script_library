/*  postgres - Base Module: Create view of Triggers in a database. A %PLACEHOLDER% expects a DB name to be provided. - ddl  */

create view devops.%DBNAME%_triggers
as
select trg.trigger_schema                as trigger_schema
      ,trg.trigger_name                  as trigger_name
      ,trg.event_manipulation            as event_dml
      ,trg.event_object_catalog          as event_database
      ,trg.event_object_schema           as event_schema
      ,trg.event_object_table            as event_object_name
      ,(select t.table_type 
          from information_schema.tables t
         where t.table_name = trg.event_object_table
           and t.table_schema = trg.event_object_schema
       )                                 as object_type
      ,pd.description                    as trigger_description
      ,trg.action_statement              as action_statement      
  from information_schema.triggers trg
       join pg_catalog.pg_trigger       pt
	     on trg.trigger_name = pt.tgname
        and trg.event_object_schema not in ('dba','information_schema','pg_catalog','public')
       left join pg_catalog.pg_description pd
              on pd.objoid = pt.oid
             and pd.classoid = (select oid from pg_catalog.pg_class where relname = 'pg_trigger')   
 order by trg.event_object_schema
         ,trg.event_object_table
         ,trg.trigger_name
         ,trg.event_manipulation
;  

comment on view devops.%DBNAME%_triggers is 'Alias: TRG - List of triggers and their descriptions from all schemas except ''dba'', ''information_schema'', ''pg_catalog'' and ''public''.';
