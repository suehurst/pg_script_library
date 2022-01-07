-- views
select v.view_schema                schema_name
      ,v.view_name                  view_name
      ,v.view_alias                 view_alias
      ,count(v.view_column_name)    column_count
      ,v.view_description           view_description
  from devops.%DBNAME%_views  v
 group by v.view_schema
         ,v.view_name
         ,v.view_alias
         ,v.view_description
 order by v.view_schema
         ,v.view_name
;
