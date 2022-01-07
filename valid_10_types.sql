-- types
select typ.type_schema
      ,typ.type_name
      ,typ.type_description
  from devops.%DBNAME%_TYPES typ  
 order by typ.type_schema
         ,typ.type_name
;

