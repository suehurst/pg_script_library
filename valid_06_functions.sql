-- functions
select fn.function_schema       schema_name
      ,fn.function_name
      ,fn.function_arguments
      ,fn.function_description
  from devops.%DBNAME%_functions fn
 order by fn.function_schema 
;
