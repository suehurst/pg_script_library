/*  postgres - BAR Module: Create View of base information (header) for historical events (DML) for those tables participating in the BAR (Backup-Audit-Recover) process. - ddl  */

-- drop view if exists devops.bar_captured_dml_events; 
create view devops.bar_captured_dml_events
as   
select bart.table_schema    as bart_table_schema
      ,bart.table_name      as bart_table_name
      ,bare.dml_event       as bare_dml_event
      ,bare.dml_item_cnt    as bare_dml_item_cnt
      ,bare.dml_ts          as bare_dml_ts
      ,bare.query           as bare_query
      ,bare.db_user         as bare_db_user
      ,bare.db_session_user as bare_db_session_user
      ,bare.catalog_name    as bare_catalog_name
      ,bare.client_addr     as bare_client_addr
      ,bare.server_addr     as bare_server_addr
      ,bare.bare_id         as bare_id 
      ,bare.bart_id         as bart_id 
      ,bare.create_dttz     as bare_create_dttz   
  from bar.captured_dml_events bare
       join bar.captured_tables bart
         on bare.bart_id = bart.bart_id
;

comment on view devops.bar_captured_dml_events is 'Alias: BARE - Captures DML event, the environment -including current user, the targeted table, and the actual SQL statement that caused rows to be inserted into bar.capture_dml_data as part of the BAR (Backup-Audit-Recovery) process.';       
comment on column devops.bar_captured_dml_events.bart_table_schema is 'Schema name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_dml_events.bart_table_name is 'Name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_dml_events.bare_dml_event is 'DML type of SQL statement that generated the event. Examples: ''INSERT'', ''UPDATE'', ''DELETE'', ''TRUNCATE''.';
comment on column devops.bar_captured_dml_events.bare_dml_ts is 'Timestamp of the DML event. Default timezone(''utc''::text, transaction_timestamp()).';
comment on column devops.bar_captured_dml_events.bare_query is 'SQL statement that generated the event. Default current_query().';
comment on column devops.bar_captured_dml_events.bare_create_dttz is 'Timestamp with timezone the row was created. Default timezone(''utc''::text, clock_timestamp()).';
comment on column devops.bar_captured_dml_events.bare_db_user is 'Database user that executed the DML statement. Default current_user.';
comment on column devops.bar_captured_dml_events.bare_db_session_user is 'User name from the device that executed the DML statement. Default session_user.';
comment on column devops.bar_captured_dml_events.bare_catalog_name is 'Database name in which the DML statement was executed. Default current_database().';
comment on column devops.bar_captured_dml_events.bare_client_addr is 'Address of the remote connection.';
comment on column devops.bar_captured_dml_events.bare_server_addr is 'Address of the local connection.'; 
comment on column devops.bar_captured_dml_events.bare_id is 'PK: Primary key on bar.captured_dml_events generated as UUID by gen_random_uuid().';
comment on column devops.bar_captured_dml_events.bart_id is 'FK: Foreign key on bar.captured_dml_events that identifies the schema and table upon which this DML statment was executed. References bar.captured_tables(bart_id).'; 

