/*  postgres - BAR Module: Create View of row detail for historical events (DML) for those tables participating in the BAR (Backup-Audit-Recover) process. - ddl  */

-- drop view if exists devops.bar_captured_dml_data; 
create view devops.bar_captured_dml_data
as
select bart.table_schema    as bart_table_schema
      ,bart.table_name      as bart_table_name        
      ,bard.row_event       as bard_row_event
      ,bard.row_data        as bard_row_data
      ,bare.query           as bare_query
      ,bard.created_seq     as bard_created_seq
      ,bard.bare_id         as bare_id
      ,bard.bart_id         as bart_id
      ,bare.create_dttz     as bare_create_dttz
  from bar.captured_dml_data bard
       join bar.captured_dml_events bare
         on bard.bare_id = bare.bare_id
       join bar.captured_tables bart
         on bard.bart_id = bart.bart_id
;

comment on view devops.bar_captured_dml_data  is 'Alias: BARD Actual data rows that were inserted, updated, deleted or truncated captured by the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_dml_data.bart_table_schema is 'Schema name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_dml_data.bart_table_name is 'Name of source table participating in the BAR (Backup-Audit-Recovery) process.';
comment on column devops.bar_captured_dml_data.bard_row_event is 'DML type of SQL statement that generated the event. Examples: ''INSERT'', ''UPDATE'', ''DELETE'', ''TRUNCATE''.';
comment on column devops.bar_captured_dml_data.bard_row_data is 'Key=>Value pairs in Hstore format of the column name and the column value of a row at the time of an insert, update or delete.';
comment on column devops.bar_captured_dml_data.bare_query is 'SQL statement from bar.captured_dml_events(query) that generated the row_data.';
comment on column devops.bar_captured_dml_data.bard_created_seq is 'PK: Primary key on bar.captured_dml_data. Unique identifier, similar to a sequence value. Default: generated always as identity.';
comment on column devops.bar_captured_dml_data.bare_id is 'FK: Foreign key on bar.captured_dml_data that links to the DML statement that created the row data. References bar.captured_dml_events(bar_id).'; 
comment on column devops.bar_captured_dml_data.bart_id is 'FK: Foreign key on bar.captured_dml_data that identifies the schema and table from which this row data originated. References bar.captured_tables(bart_id).'; 
comment on column devops.bar_captured_dml_data.bare_create_dttz is 'Timestamp with time zone of the DML event and the capture of the resulting row data.';
