/*  postgres - BAR Module: Create View to identify the tables participating in the BAR (Backup-Audit-Recover) process. - ddl  */

create view devops.bar_captured_tables
as
select bart.table_schema       as bart_table_schema  
      ,bart.table_name         as bart_table_name
      ,bart.start_capture_ts   as bart_start_capture_ts
      ,bart.end_capture_ts     as bart_end_capture_ts
      ,bart.last_maint_ts      as bart_last_maint_ts
      ,bart.bart_id            as bart_id
  from bar.captured_tables bart
;

comment on view devops.bar_captured_tables is 'Alias: BART - Master list of tables that are protected by the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_tables.bart_table_schema is 'Schema name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_tables.bart_table_name is 'Name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_tables.bart_start_capture_ts is 'Start time of BAR participation for this source table. Default: timezone(''utc''::text, transaction_timestamp()).';
comment on column devops.bar_captured_tables.bart_end_capture_ts is 'End time to stop BAR participation for this source table. Default: ''infinity''::timestamp.';
comment on column devops.bar_captured_tables.bart_last_maint_ts is 'Last time changes were made to the BAR participation specifications for this source table. Default: ''infinity''::timestamp.';
comment on column devops.bar_captured_tables.bart_id is 'PK: Primary key generated as default  bar.gen_id() which creates the md5 value of concatenated timestamp + PID + DML statement.';  
