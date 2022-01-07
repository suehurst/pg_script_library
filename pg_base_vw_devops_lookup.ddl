/*  postgres - Base Module: Create view of Lookup Data from joining both chief.lookup_categories and chief.lookup_data. - ddl  */

-- drop trigger lookup_iur_trg on devops.lookup;
-- drop view devops.lookup;
create view devops.lookup 
as
select ldat.name           as ldat_name
      ,ldat.description    as ldat_description
      ,lcat.name           as lcat_name
      ,lcat.description    as lcat_description          
      ,ldat.v_name         as ldat_v_name
      ,lcat.v_name         as lcat_v_name
      ,srcc.name           as lcat_src_name
      ,srcc.orig_source_ident   as lcat_src_orig_source_ident  
      ,srcd.name           as ldat_src_name
      ,srcd.orig_source_ident   as ldat_src_orig_source_ident            
      ,ldat.ldat_id        as ldat_id
      ,ldat.lcat_id        as lcat_id
	  ,srcc.src_id         as lcat_src_id
	  ,srcd.src_id         as ldat_src_id
	  ,lcat.create_dttz    as lcat_create_dttz
	  ,ldat.create_dttz    as ldat_create_dttz
  from chief.lookup_data ldat
       join chief.lookup_categories lcat
	     on ldat.lcat_id = lcat.lcat_id
       join chief.sources    srcc
	     on lcat.src_id = srcc.src_id
       join chief.sources    srcd
	     on ldat.src_id = srcd.src_id
;

comment on view devops.lookup is 'Alias: LKUP - Master list of Lookup Data and Categories. Useful for provisioning drop-down lists in UIs (User Interfaces).';

-- For reference only. Trigger will be created after all other objects have been created.
-- create trigger lookup_iur_trg instead of update on devops.lookup for each row execute procedure devops.lookup_update();
-- comment on trigger lookup_iur_trg on devops.lookup is 'Trigger executes procedure devops.lookup_update()';
