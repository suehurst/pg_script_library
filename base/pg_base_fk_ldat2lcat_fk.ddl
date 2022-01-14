/* postgres - Base Module: Create Foreign Key ldat2lcat_fk on chief.lookup_data.lcat_id. References chief.lookup_categories (lcat_id). - ddl  */

alter table chief.lookup_data add constraint ldat2lcat_fk foreign key (lcat_id) references chief.lookup_categories(lcat_id);

comment on constraint ldat2lcat_fk on chief.lookup_data is 'FK on chief.lookup_data.lcat_id. References chief.lookup_categories (lcat_id).';
