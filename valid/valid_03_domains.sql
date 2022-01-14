-- domains
select dom.domain_schema
      ,dom.domain_name
      ,dom.data_type
      ,dom.default_value
      ,dom.domain_description
      ,dom.is_nullable
  from devops.%DBNAME%_domains dom
;
