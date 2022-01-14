/*  postgres - Base Module: Create Sources staging table in stg schema. - ddl  */

-- drop table stg.sources;
create table stg.sources
      (src_id            chief.std_pk
      ,name              text
      ,description       text
      ,orig_source_ident text
      ,migrated_dttz     text default '-infinity'
      ,constraint src_pk primary key (src_id)
      )
;

comment on table stg.sources is 'Alias: SRC - Staging table to prepare new data for loading into chief.sources.';
comment on column stg.sources.src_id is 'PK: Primary key generated as a random type 4 UUID.';
comment on column stg.sources.name is 'Name of the source such as a module that inserted a row of data, a legacy system that was merged into the system or an external source such as a geospatial component, genealogy record, etc.';
comment on column stg.sources.description is 'Description of the source.';
comment on column stg.sources.migrated_dttz is 'Default is ''-infinity''. Date will be reset at load time when staged data are loaded into chief.sources.';
