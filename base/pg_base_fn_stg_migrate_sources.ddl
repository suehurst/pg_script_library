/*  postgres - Base Module: Create function to batch load Sources from stg.sources to chief.sources. - ddl  */

create or replace function stg.migrate_sources()
returns table (migrate_action text
              ,migrate_items bigint
              )
language sql
as 
$$
        /* Write error message so User knows what and why an entry failed. Missing names can be the only error for sources. */ 
   with errs as
        (insert into stg.load_reject_log 
               (message
               ,rejecting_function
               ,identifier
               )
         select 'M-SRC001: Could not create Source: ' ||
                ' because stg.source.name is empty'
               ,'stg.migrate_sources()'
               ,'Source Name:' || src.name
           from stg.sources  src
          where src.name = ''
            and src.migrated_dttz = '-infinity'
         union
         select 'M-SRC002: Could not create Source: ' ||
                ' because stg.source.name is null'
               ,'stg.migrate_sources()'
               ,'Source Name:' || src.name
           from stg.sources  src
          where src.name is null
            and src.migrated_dttz = '-infinity'
         returning 1
        )
        /* There are no predecessors so go ahead and insert new sources into chief.sources. */
       ,new_src as
        (insert into chief.sources
               (name
               ,description
               ,orig_source_ident
               )
         select src.name
               ,src.description
               ,src.orig_source_ident
           from stg.sources  src
          where (src.name is not null
                 and
                 src.name != ''
                )
            and src.migrated_dttz = '-infinity'
         on conflict do nothing
         returning name
        )
        /* Update the migrated_dttz in stg.sources so these rows will be excluded from future batch loads. */
       ,migrated as
        (update stg.sources stg
            set migrated_dttz = now()
           from new_src src
          where stg.name = src.name
            and stg.migrated_dttz = '-infinity'
         returning stg.name
        )
    select 'Reject_logs: ',count(*) Inserted from errs
    union all        
    select 'Sources:',count(*) from migrated
    ;
$$;


comment on function stg.migrate_sources() is 'Routine to bulk load sources into chief.sources. Precondition: batch load data must be in stg.sources before loading.';
