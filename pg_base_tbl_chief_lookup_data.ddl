/*  postgres - Base Module: Create storage table for Lookup Data (fka rows in lookup tables) in the chief schema. - ddl  */

-- drop table chief.lookup_data;
create table chief.lookup_data
      (ldat_id           chief.std_pk
      ,lcat_id           chief.std_id  not null
      ,name              chief.std_name not null
      ,description       chief.std_description
      ,src_id            chief.std_id  not null
      ,orig_source_ident chief.std_foreign_ident
      ,v_name            text generated always as (store.virtual_string(name)) stored
      ,create_dttz       chief.std_create_dttz
      ,constraint ldat_pk primary key (ldat_id)
      ,constraint ldat_bk unique (lcat_id,v_name)
      )
;

comment on table chief.lookup_data is 'Alias: LDAT - Lookup data elements for each lookup category. Data elements for each lookup category are equivalent to rows in a lookup table. Names are unique within each lookup category. Example: category = ''address_type'' may have lookup data names in (''home'', ''work'') while category = ''email_type'' may have lookup data names in (''home'', ''work'') with different lookup data IDs and different category IDs. This table cannot be a parent table. No child records are allowed for this table other than views that display the lookup data name. If child records are needed, a separate table must be created for the category and its data elements.';
comment on column chief.lookup_data.ldat_id is 'PK: Primary key generated as UUID by gen_random_uuid().';
comment on column chief.lookup_data.lcat_id is 'Lookup category mechanism for grouping lookup data elements for a common purpose. It is equivalent to the ''table name'' for a collection of lookup data elements. FK: References chief.lookup_categories(lcat_id).';
comment on column chief.lookup_data.name is 'Name of a specific lookup data element. A collection of lookup data elements defines the ''rows'' that belong to a lookup category. It may also be used as a display name in a drop down list.';
comment on column chief.lookup_data.description is 'Description of the lookup data element. This is helpful when the name is an acronym, a code or when a lookup data element must be selected for a specific purpose.';
comment on column chief.lookup_data.src_id is 'Identifier the software module or legacy system that inserted the row. FK: References chief.sources(src_id).';
comment on column chief.lookup_data.orig_source_ident is 'Original identifier for the same entity that was migrated from a legacy or external source.';
comment on column chief.lookup_data.v_name is 'Virtual column to ensure uniqueness of the lookup data name.  It compares the lower case version and digits of the name without spaces or special characters to any other values that may already exist with that name.';
comment on column chief.lookup_data.create_dttz is 'Timestamp with time zone of the original insertion of the row.';

/****** For reference only. Foreign Keys will be created after all tables have been created. ******
alter table chief.lookup_data add constraint ldat2lcat_fk foreign key (lcat_id) references chief.lookup_categories(lcat_id);
alter table chief.lookup_data add constraint ldat2src_fk foreign key (src_id) references chief.sources(src_id);
comment on constraint ldat2lcat_fk on chief.lookup_data is 'FK on chief.lookup_data.lcat_id. References chief.lookup_categories (lcat_id).';
comment on constraint ldat2src_fk on chief.lookup_data is 'FK on chief.lookup_data.src_id. References chief.sources (src_id).';
*/
