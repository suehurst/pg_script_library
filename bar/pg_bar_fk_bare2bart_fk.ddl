/*  postgres - BAR Module: Create Foreign Key bare2bart_fk on bar.captured_dml_events. References bar.captured_tables(bart_id). - ddl  */

alter table bar.captured_dml_events add constraint bare2bart_fk foreign key (bart_id) references bar.captured_tables(bart_id);

comment on constraint bare2bart_fk on bar.captured_dml_events is 'FK: Foreign key on bar.captured_dml_events.bart_id references bar.captured_tables(bart_id).';
