-- triggers
select trg.trigger_schema
      ,trg.trigger_name
      ,trg.event_dml
      ,trg.event_database
      ,trg.event_schema
      ,trg.event_object_name
      ,trg.object_type
      ,trg.trigger_description
      ,trg.action_statement
  from devops.%DBNAME%_triggers trg  
 order by trg.trigger_schema
         ,trg.event_object_name
         ,trg.trigger_name
         ,trg.event_dml
;

