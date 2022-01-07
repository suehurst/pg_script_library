-- foreign keys
select fk.table_schema
      ,fk.foreign_key_name
      ,fk.table_name
      ,fk.column_name
      ,fk.foreign_table_schema
      ,fk.foreign_table_name
      ,fk.foreign_column_name 
      ,fk.foreign_key_description
  from devops.%DBNAME%_foreign_keys fk
 order by fk.table_schema
         ,fk.table_name
         ,fk.foreign_key_name
;

