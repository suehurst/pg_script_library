/*  postgres - Base Module: Create Lookup staging table in stg schema. - ddl  */

-- drop table stg.lookup;
create table stg.lookup
      (lkup_id           chief.std_pk
      ,lcat_name         text
      ,lcat_description  text
      ,ldat_name         text
      ,ldat_description  text
      ,source            text
      ,orig_source_ident text
      ,migrated_dttz     text default '-infinity'
      ,constraint lkup_pk primary key (lkup_id)
      )
;

comment on table stg.lookup is 'Alias: LKUP - Staging table to prepare new data for loading into chief.lookup_categories and/or chief.lookup_data.';
comment on column stg.lookup.lkup_id is 'PK: Primary key generated as a random type 4 UUID.';
comment on column stg.lookup.lcat_name is 'Name of a lookup category. It is equivalent to the ''table name'' for a collection of lookup data elements. Each category is associated to any number of lookup data elements in chief.lookup_data.';
comment on column stg.lookup.lcat_description is 'Description to help understand the purpose of each category.';
comment on column stg.lookup.ldat_name is 'Value of a lookup data element. A collection of lookup data elements defines the ''rows'' that belong to a lookup category.';
comment on column stg.lookup.ldat_description is 'Description of the lookup data element. This is helpful when the name is an acronym or code. It may also be used as a display name in a drop down list.';
comment on column stg.lookup.source is 'Name of the source such as a module that performed a DML for each row of data, a legacy system that was merged into the system or an external source such as a geospatial component, genealogy record, etc.';
comment on column stg.lookup.orig_source_ident is 'Original identifier for the same entity that was migrated from a legacy or external source.';
comment on column stg.lookup.migrated_dttz is 'Default is ''-infinity''. Date will be reset at load time when staged data are loaded into chief.lookup_categories and chief.lookup_data.';

