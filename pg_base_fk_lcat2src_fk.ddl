/* postgres - Base Module: Create Foreign Key lcat2src_fk on chief.lookup_categories.src_id. References chief.sources (src_id). - ddl  */

alter table chief.lookup_categories add constraint lcat2src_fk foreign key (src_id) references chief.sources(src_id);

comment on constraint lcat2src_fk on chief.lookup_categories is 'FK on chief.lookup_categories.src_id. References chief.sources (src_id).';
