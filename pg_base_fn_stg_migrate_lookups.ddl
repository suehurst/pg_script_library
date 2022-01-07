/*  postgres - Base Module: Create function to batch load Lookup data from stg.lookup to chief.lookup_cateogries and chief.lookup_data. - ddl  */

create or replace function stg.migrate_lookups()
returns table (migrate_action text 
              ,migrate_items  bigint
              )
language sql
volatile
as 
$$
         /* Identify missing or invalid Sources. */
    with invalids (cat_name,cat_desc,dat_name,dat_desc,source) as 
         (select stg.lcat_name
                ,stg.lcat_description
                ,stg.ldat_name
                ,stg.ldat_description
                ,stg.source
            from stg.lookup stg
           where not exists (select * --null 
                               from chief.sources src
                              where src.v_name = store.virtual_string(stg.source)
                            )
         ) 
         /* Write error message so User knows what and why an entry failed. */ 
        ,errs as
         (insert into stg.load_reject_log
                (message
                ,rejecting_function
                ,identifier
                ) 
          select case 
                 when source is not null 
                 then
                      'LK001: Could not create Lookup: ' ||
                      cat_name||'.'||dat_name  ||
                      ' because Source: '       ||source||
                      ' does not exist in chief.sources.' 
                 else 'LK002: Could not create Lookup: ' ||
                      cat_name||'.'||dat_name  ||
                      ' because stg.lookup.source is missing (null).'
                 end 
                ,'Test Load: Stg.lookup' 
                ,cat_name || '.' || dat_name 
            from invalids
          returning identifier
         ) 
         /* Insert new Lookup Categories into chief.lookup_categories. Return lcat_id if a category already exists. */
        ,new_lcat as 
         (insert into chief.lookup_categories
                (name
                ,description
                ,orig_source_ident
                ,src_id
                )  
          select lcat_name
                ,lcat_description
                ,orig_source_ident
                ,src_id
            from (select distinct on (store.virtual_string(stg.lcat_name))
                         store.virtual_string(stg.lcat_name)
                        ,stg.lcat_name
                        ,stg.lcat_description
                        ,src.orig_source_ident
                        ,src.src_id
                    from chief.sources src
                         join stg.lookup    stg  
                           on (src.v_name = store.virtual_string(stg.source))
                         left join invalids     
                                on (stg.lcat_name,stg.ldat_name) = (cat_name,dat_name)
                             where cat_name is null
                             order by store.virtual_string(stg.lcat_name)
                 ) sqn
          on conflict do nothing
          returning v_name
                   ,lcat_id 
         ) 
         /* Insert new Lookup Data into chief.lookup_data using lcat_id from previous step: new_lcat. */
        ,new_ldat as 
         (insert into chief.lookup_data
                (name
                ,description
                ,orig_source_ident
                ,src_id
                ,lcat_id
                )    
          select distinct on (stg.ldat_name)
                 stg.ldat_name
                ,stg.ldat_description
                ,stg.orig_source_ident
                ,src.src_id
                ,sqn.lcat_id 
            from chief.sources src
                 join stg.lookup    stg  
                   on src.v_name = store.virtual_string(stg.source)
                 join (select lcat.v_name
                             ,lcat.lcat_id
                         from chief.lookup_categories lcat
                       union 
                       select v_name,lcat_id   
                         from new_lcat
                      ) sqn 
                   on (sqn.v_name = store.virtual_string(stg.lcat_name))               
           order by stg.ldat_name
          on conflict do nothing             
          returning name
         ) 
         /* Update the migrated_dttz in stg.lookup so these rows will be excluded from future batch loads. */
        ,migrated as 
         (update stg.lookup stg 
             set migrated_dttz = transaction_timestamp()::text
           where not exists (select null 
                               from invalids 
                              where (stg.lcat_name,stg.ldat_name) = (cat_name,dat_name)
                            )
             and migrated_dttz = '-infinity'::text
          returning migrated_dttz
         ) 
    select 'Reject_logs: ',count(*) Inserted from errs
    union all
    select 'Lookup_Categories: ',count(*) from new_lcat
    union all
    select 'Lookup_Data: ',count(*) from new_ldat
    union all
    select 'Migrated Stg.Lookup: ',count(*) from migrated
    ;
$$;	

comment on function stg.migrate_lookups() is 'Routine to bulk load Lookup Categories and/or Data into chief.lookup_categories and chief.lookup_data. Also logs rejected entries in stg.load_reject_log. Precondition: source data must be in stg.lookup before loading.';
