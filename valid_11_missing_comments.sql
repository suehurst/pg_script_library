-- missing comments
-- schemas
select sch.schema_name    "schema"
      ,sch.schema_owner   object_type
      ,sch.schema_name    "name"	  
  from devops.%DBNAME%_schemas sch
 where sch.schema_description is null
union
-- domains
select dom.domain_schema  "schema"
      ,'Domain'::text      object_type
      ,dom.domain_name    "name"
  from devops.%DBNAME%_domains dom
 where dom.domain_description is null
union
-- tables
select tc.table_schema    "schema"
      ,'Table'::text       object_type
      ,tc.table_name      "name"
  from devops.%DBNAME%_tables_columns tc
 where tc.table_description is null
union
-- columns
select tc.table_schema    "schema"
      ,'Column'::text      object_type
      ,tc.column_name||' on Table: '||tc.table_name    "name"
  from devops.%DBNAME%_tables_columns tc
 where tc.column_description is null
union
-- functions
select fn.function_schema "schema"
      ,'Function'::text    object_type
      ,fn.function_name   "name"
  from devops.%DBNAME%_functions fn
 where fn.function_description is null
union
-- views
select vw.view_schema     "schema"
      ,'View'::text        object_type
      ,vw.view_name       "name"
  from devops.%DBNAME%_views vw
 where vw.view_description is null
union
-- foreign_keys
select fk.table_schema     "schema"
      ,'Foreign Key'::text  object_type
      ,fk.foreign_key_name "name"
  from devops.%DBNAME%_foreign_keys fk
 where fk.foreign_key_description is null
union
-- triggers
select trg.trigger_schema   "schema"
      ,'Trigger'::text       object_type
      ,trg.trigger_name     "name"
  from devops.%DBNAME%_triggers trg
 where trg.trigger_description is null
union
-- types
select typ.type_schema      "schema"
      ,'Type'::text         object_type
      ,typ.type_name       "name"
  from devops.%DBNAME%_types typ
 where typ.type_description is null
;







