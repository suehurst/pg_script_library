/* postgres - Foreign Data Wrappers Module: Create Foreign Data Wrapper. - ddl  */
/*  Note: must have .pgpass file populated with user credentials in /home/repositories/ before installing foreign data wrapper  */
-- add extension in local database that wants to connect to a foreign database on another server
create extension if not exists %FDW_HANDLER%;

create foreign data wrapper %FDW_HANDLER%
     handler public.%FDW_HANDLER%_handler
     validator public.%FDW_HANDLER%_validator
;

create server %SERVERNAME% foreign data wrapper %FDW_HANDLER%
  options (host '%HOST%', dbname '%FOREIGNDBNAME%', port '%PORT%')
;

-- create user mappings to foreign database
create user mapping for %DBNAME%_user server %SERVERNAME% options (user '%DBNAME%_user', password '%PASSW%');  
create user mapping for %DBNAME%_admin server %SERVERNAME% options (user '%DBNAME%_admin', password '%PASSW%');  
create user mapping for %DBNAME% server %SERVERNAME% options (user '%DBNAME%', password '%PASSW%');  
grant usage on foreign server %SERVERNAME% to %DBNAME%_admin;  
grant usage on foreign server %SERVERNAME% to %DBNAME%_user; 
grant usage on foreign server %SERVERNAME% to %DBNAME%; 

/* foreign data wrappers */
comment on foreign data wrapper %FDW_HANDLER% is 'Foreign data wrapper (FDW) using FDW handler %FDW_HANDLER% from %DBNAME% to the %FOREIGNDBNAME% database. Objects in the foreign database may be accessed via %FOREIGNDBNAME%server from the host database.';
