/*  postgres - BAR Module: Create storage Table to capture base information (header) for historical events (DML) for those tables participating in the BAR (Backup-Audit-Recover) process. - ddl  */

-- drop table if exists bar.captured_dml_events cascade; 
create table bar.captured_dml_events
      (bare_id         uuid           
      ,bart_id         uuid          
      ,dml_event       text          not null
      ,dml_item_cnt    integer
      ,dml_ts          timestamp(6)  not null default timezone('utc'::text,transaction_timestamp())
      ,query           text          not null default current_query()
      ,create_dttz     timestamp(6)  not null default timezone('utc'::text,clock_timestamp())
      ,db_user         name          not null default current_user
      ,db_session_user name          not null default session_user
      ,catalog_name    name          not null default current_database()
      ,client_addr     text          not null default inet_client_addr()
      ,server_addr     text          not null default inet_server_addr()
      ,constraint      bare_pk       primary key(bare_id,bart_id) 
      )
;

comment on table bar.captured_dml_events is 'Alias: BARE - Captures DML event, the environment -including current user, the targeted table, and the actual SQL statement that caused rows to be inserted into bar.bar_rows as part of the BAR (Backup-Audit-Recovery) process.';
comment on column bar.captured_dml_events.bare_id is 'PK: Primary key generated as UUID by gen_random_uuid().';
comment on column bar.captured_dml_events.bart_id is 'FK: Foreign key on bar.captured_dml_events that identifies the schema and table upon which this DML statment was executed. References bar.captured_tables(bart_id).';        
comment on column bar.captured_dml_events.dml_event is 'DML type of SQL statement that generated the event. Examples: ''INSERT'', ''UPDATE'', ''DELETE'', ''TRUNCATE''.';
comment on column bar.captured_dml_events.dml_ts is 'Timestamp of the DML event. Default timezone(''utc''::text, transaction_timestamp()).';
comment on column bar.captured_dml_events.query is 'SQL statement that generated the event. Default current_query().';
comment on column bar.captured_dml_events.create_dttz is 'Timestamp with timezone the row was created. Default timezone(''utc''::text, clock_timestamp()).';
comment on column bar.captured_dml_events.db_user is 'Database user that executed the DML statement. Default current_user.';
comment on column bar.captured_dml_events.db_session_user is 'User name from the device that executed the DML statement. Default session_user.';
comment on column bar.captured_dml_events.catalog_name is 'Database name in which the DML statement was executed. Default current_database().';
comment on column bar.captured_dml_events.client_addr is 'Address of the remote connection.';
comment on column bar.captured_dml_events.server_addr is 'Address of the local connection.'; 

