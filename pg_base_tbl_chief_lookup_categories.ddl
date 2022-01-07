/*  postgres - Base Module: Create storage table for Lookup Categories (fka lookup tables) in the chief schema. - ddl  */

-- drop table chief.lookup_categories;
create table chief.lookup_categories
      (lcat_id           chief.std_pk
      ,name              chief.std_name not null
      ,description       chief.std_description
      ,src_id            chief.std_id  not null
      ,orig_source_ident chief.std_foreign_ident
      ,v_name            text generated always as (store.virtual_string(name)) stored
      ,create_dttz       chief.std_create_dttz
      ,constraint lcat_pk primary key (lcat_id)
      ,constraint lcat_bk unique (v_name)
      )
;

comment on table chief.lookup_categories is 'Alias: LCAT - Master table for categorizing lookup data into specific business functions. A category is equivalent to the name of a lookup table. The only child records allowed for this table are the lookup data elements in lookup_data (ldat) or views that want to display the lookup category name. Any category that requires child records other than ldat must be in its own table.';
comment on column chief.lookup_categories.lcat_id is 'PK: Primary key generated as UUID by gen_random_uuid().';
comment on column chief.lookup_categories.name is 'Name of a lookup category. It is equivalent to the ''table name'' for a collection of lookup data elements. Each category is associated to any number of lookup data elements in chief.lookup_data.';
comment on column chief.lookup_categories.description is 'Description to help understand the purpose of each category.';
comment on column chief.lookup_categories.src_id is 'Identifier the software module or legacy system that inserted the row. FK: References chief.sources(src_id).';
comment on column chief.lookup_categories.orig_source_ident is 'Original identifier for the same entity that was migrated from a legacy or external source.';
comment on column chief.lookup_categories.v_name is 'Virtual column to ensure uniqueness of the lookup category name.  It compares the lower case version and digits of the name without spaces or special characters to any other values that may already exist with that name.';
comment on column chief.lookup_categories.create_dttz is 'Timestamp with time zone of the original insertion of the row.';

/****** For reference only. Foreign Keys will be created after all tables have been created. ******
alter table chief.lookup_categories add constraint lcat2src_fk foreign key (src_id) references chief.sources(src_id);
comment on constraint lcat2src_fk on chief.lookup_categories is 'FK on chief.lookup_categories.src_id. References chief.sources (src_id).';
*/
