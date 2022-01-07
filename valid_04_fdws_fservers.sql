-- foreign data wrappers
select distinct
       fdw.foreign_data_wrapper_dbname
      ,fdw.foreign_data_wrapper_name
      ,fdw.foreign_server_dbname
      ,fdw.foreign_server_name
      ,fdw.remote_db_connection
  from devops.%DBNAME%_foreign_data_wrappers fdw
;


