/* postgres - Base Module: Create Foreign Key ldat2src_fk on chief.lookup_data.src_id. References chief.sources (src_id). - ddl  */

alter table chief.lookup_data add constraint ldat2src_fk foreign key (src_id) references chief.sources(src_id);

comment on constraint ldat2src_fk on chief.lookup_data is 'FK on chief.lookup_data.src_id. References chief.sources (src_id).';
