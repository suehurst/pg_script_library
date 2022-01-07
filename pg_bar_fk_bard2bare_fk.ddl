/*  postgres - BAR Module: Create Foreign Key bard2bare_fk on bar.captured_dml_events. References bar.captured_dml_events(bare_id, bart_id). - ddl  */

alter table bar.captured_dml_data add constraint bard2bare_fk foreign key (bare_id,bart_id) references bar.captured_dml_events(bare_id, bart_id) deferrable initially deferred;

comment on constraint bard2bare_fk on bar.captured_dml_data  is 'FK: Foreign key bar.captured_dml_data(bare_id,bart_id) references bar.captured_dml_events(bare_id, bart_id).';
