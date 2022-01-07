/*  postgres - BAR Module: Create storage Table the tables participating in the BAR (Backup-Audit-Recover) process. - ddl  */

-- drop table if exists bar.captured_tables cascade;
create table bar.captured_tables 
      (bart_id          uuid         default  bar.gen_id()    
      ,table_schema     name         not null 
      ,table_name       name         not null
      ,start_capture_ts timestamp(6) not null default timezone('utc'::text,transaction_timestamp())
      ,end_capture_ts   timestamp(6) not null default 'infinity'::timestamp 
      ,last_maint_ts    timestamp(6) not null default '-infinity'::timestamp 
      ,constraint       bart_pk      primary key(bart_id)
      )
;

create unique index captured_tables_pui  -- partial_unique_index 
    on bar.captured_tables (table_schema,table_name,end_capture_ts)
 where end_capture_ts = 'infinity'::timestamp
;

comment on table bar.captured_tables is 'Alias: BART - Master list of tables that are protected by the BAR (Backup-Audit-Recovery) process.';
comment on column bar.captured_tables.bart_id is 'PK: Primary key generated as default  bar.gen_id() which creates the md5 value of concatenated timestamp + PID + DML statement.';  
comment on column bar.captured_tables.table_schema is 'Schema name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column bar.captured_tables.table_name is 'Name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column bar.captured_tables.start_capture_ts is 'Start time of BAR participation for this source table. Default: timezone(''utc''::text, transaction_timestamp()).';
comment on column bar.captured_tables.end_capture_ts is 'End time to stop BAR participation for this source table. Default: ''infinity''::timestamp.';
comment on column bar.captured_tables.last_maint_ts is 'Last time changes were made to the BAR participation specifications for this source table. Default: ''infinity''::timestamp.';
comment on index captured_tables_pui is 'Partial unique index on the schema, table and end timestamp of a table participating in the BAR process.';
