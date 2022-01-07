-- tables
select tc.table_schema       schema_name
      ,tc.table_name
      ,tc.table_alias
      ,count(tc.column_name) column_count
      ,tc.table_description  table_description
  from devops.%DBNAME%_tables_columns tc
 group by tc.table_schema
         ,tc.table_name
         ,tc.table_alias
         ,tc.table_description
 order by tc.table_schema
         ,tc.table_name
;


