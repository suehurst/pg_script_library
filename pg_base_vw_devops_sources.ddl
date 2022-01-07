/*  postgres - Base Module: Create view of Sources as stored in chief.sources. - ddl  */

-- drop trigger sources_iur_trg on devops.sources;
-- drop view devops.sources;
create view devops.sources
as
select src.name               as src_name         
      ,src.description        as src_description  
      ,src.orig_source_ident  as src_orig_source_ident
      ,src.v_name             as src_v_name
      ,src.src_id             as src_id
      ,src.create_dttz        as src_create_dttz
  from chief.sources src
;

comment on view devops.sources is 'Alias: SRC - Master list of data sources such as the modules that performed a DML for each row of data, a legacy system that was merged into the system or an external source: a geospatial component, genealogy record, etc.';

-- For reference only. Trigger will be created after all other objects have been created.
-- create trigger sources_iur_trg instead of update on devops.sources for each row execute procedure devops.sources_update();
-- comment on trigger sources_iur_trg on devops.sources is 'Trigger executes procedure devops.source_update()';

