/* installed objects */
-- business_keys
select bk.table_schema      "Schema"     
      ,bk.business_key_name "Object Name"
      ,'Business Key'::text "Type"
  from devops.%DBNAME%_business_keys bk
union
-- domains
select dom.domain_schema  "Schema" 
      ,dom.domain_name    "Object Name"
      ,'Domain'::text     "Type"
  from devops.%DBNAME%_domains dom
union
-- foreign_keys
select fk.table_schema     "Schema"     
      ,fk.foreign_key_name "Object Name"
      ,'Foreign Key'::text "Type"
  from devops.%DBNAME%_foreign_keys fk
union
-- functions
select fn.function_schema "Schema"     
      ,fn.function_name   "Object Name"
      ,'Function'::text   "Type"
  from devops.%DBNAME%_functions fn
union
-- primary_keys
select pk.table_schema      "Schema"     
      ,pk.primary_key_name  "Object Name"
      ,'Primary Key'::text  "Type"
  from devops.%DBNAME%_primary_keys pk
union
-- tables
select distinct tc.table_schema    "Schema"   
      ,tc.table_name      "Object Name"
      ,'Table'::text      "Type"
  from devops.%DBNAME%_tables_columns tc
union
-- table_columns
select tc.table_schema    "Schema"     
      ,tc.table_name||'.'||tc.column_name "Object Name"
      ,'Table Column'::text "Type"
  from devops.%DBNAME%_tables_columns tc
union
-- triggers
select trg.trigger_schema   "Schema"     
      ,trg.trigger_name     "Object Name"
      ,'Trigger'::text      "Type"
  from devops.%DBNAME%_triggers trg
union
-- types
select typ.type_schema      "Schema"      
      ,typ.type_name        "Object Name"
      ,'Type'::text         "Type"
  from devops.%DBNAME%_types typ
union
-- views
select distinct vw.view_schema "Schema"    
      ,vw.view_name       "Object Name"
      ,'View'::text       "Type"
  from devops.%DBNAME%_views vw
order by "Schema"
        ,"Type"
        ,"Object Name"
;







