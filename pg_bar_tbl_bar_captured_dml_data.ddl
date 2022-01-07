/*  postgres - BAR Module: Create storage Table to capture row detail for historical events (DML) for those tables participating in the BAR (Backup-Audit-Recover) process. - ddl  */

-- drop table if exists bar.captured_dml_data cascade; 
create table bar.captured_dml_data
      (created_seq     bigint     generated always as identity
      ,bare_id         uuid       not null
      ,bart_id         uuid       not null
      ,row_event       text       not null 
      ,row_data        hstore     not null   
      ,constraint      bard_pk    primary key(created_seq) 
      )
;

create index captured_dml_data_indx 
          on bar.captured_dml_data(bare_id,bart_id);
          
comment on table bar.captured_dml_data  is 'Alias: BARD Actual data rows that were inserted, updated, deleted or truncated captured by the BAR (Backup-Audit-Recovery) process.';
comment on column bar.captured_dml_data.created_seq is 'Unique identifier, similar to a sequence value. Default: generated always as identity.';
comment on column bar.captured_dml_data.bare_id is 'FK: Foreign key on bar.captured_dml_data that links to the DML statement that created the row data. References bar.captured_dml_events(bar_id).'; 
comment on column bar.captured_dml_data.bart_id is 'FK: Foreign key on bar.captured_dml_data that identifies the schema and table from which this row data originated. References bar.captured_tables(bart_id).'; 
comment on column bar.captured_dml_data.row_data is 'Key=>value pairs in Hstore format of the column name and the column value of a row at the time of an insert, update or delete.';

/****** For reference only. Foreign Keys will be created after all tables have been created. ******
alter table bar.captured_dml_data add constraint bard2bare_fk foreign key (bare_id,bart_id) references bar.captured_dml_events(bare_id, bart_id) deferrable initially deferred;
comment on constraint bard2bare_fk on bar.captured_dml_data  is 'FK: Foreign key bar.captured_dml_data(bare_id,bart_id) references bar.captured_dml_events(bare_id, bart_id).';
*/
