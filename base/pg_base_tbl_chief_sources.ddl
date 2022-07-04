/*  postgres - Base Module: Create storage table for Sources (where did the data come from?) in the chief schema. - ddl  */

-- drop table chief.sources;
create table chief.sources
      (src_id            chief.std_pk
      ,name              chief.std_name not null
      ,description       chief.std_description
      ,orig_source_ident chief.std_foreign_ident
      ,v_name            text generated always as (store.virtual_string(name)) stored
      ,create_dttz       chief.std_create_dttz
      ,constraint src_pk primary key (src_id)
      ,constraint src_bk unique (v_name)
      ,constraint src_name_ck check (name <> '')
      )
;

comment on table chief.sources is 'Alias: SRC - Identifier of data sources such as the modules that performed a DML for each row of data, a legacy system that was merged into the system or an external source: a geospatial component, genealogy record, etc.';
comment on column chief.sources.src_id is 'PK: Primary key generated as UUID by gen_random_uuid().';
comment on column chief.sources.name is 'Name of the source such as a module that inserted a row of data, a legacy system that was merged into the system or an external source such as a geospatial component, genealogy record, etc.';
comment on column chief.sources.description is 'Description of the source.';
comment on column chief.sources.orig_source_ident is 'Original identifier for the same entity that was migrated from a legacy or external source.';
comment on column chief.sources.v_name is 'Virtual column to ensure uniqueness of the source name. It compares the lower case version and digits of the name without spaces or special characters to any other values that may already exist with that name.';
comment on column chief.sources.create_dttz is 'Timestamp with time zone of the original insertion of the row.';
comment on constraint src_bk on chief.sources is 'Business Key on chief.sources. Unique constraint on (v_name).';
comment on constraint src_name_ck on chief.sources is 'Check constraint on chief.sources.name to disallow an empty string '''' value.';
