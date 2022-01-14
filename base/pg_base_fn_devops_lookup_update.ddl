/*  postgres - Base Module: Create trigger function to safely update lookup categories and data in devops.lookup view.
    To be used with a UI for updating a Lookup Category and/or a Lookup Data entity. - ddl  
*/

-- drop function devops.lookup_update() cascade;
create function devops.lookup_update() 
returns trigger
language plpgsql
as 
$$
declare
    k_invalid_col_msg  text = E'LDAT10: Invalid column reference for update.  _ID and v_ and create_dttz columns cannot be updated. Update attempts to update columns\n\t%' ;
    l_invalid_col_list text = '';
    l_lcat_id chief.std_id;
    l_lcat_src_id chief.std_id;   
    l_ldat_src_id chief.std_id;   
begin
     -- raise info 'Enter Trigger Function devops.lookup_update() for old name = %',old.lcat_v_name::text;
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('lcat_v_name'::text,new.lcat_v_name::text,old.lcat_v_name::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('lcat_id'::text,new.lcat_id::text,old.lcat_id::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('lcat_create_dttz'::text,new.lcat_create_dttz::text,old.lcat_create_dttz::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('ldat_v_name'::text,new.ldat_v_name::text,old.ldat_v_name::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('ldat_id'::text,new.ldat_id::text,old.ldat_id::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('ldat_create_dttz'::text,new.ldat_create_dttz::text,old.ldat_create_dttz::text); 
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('lcat_src_id'::text,new.lcat_src_id::text,old.lcat_src_id::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('ldat_src_id'::text,new.ldat_src_id::text,old.ldat_src_id::text);
    if length(l_invalid_col_list) > 0
    then
        raise exception '% %',k_invalid_col_msg,trim(l_invalid_col_list,',')
              using hint = E'To update _ids use the name of entity.\nv_ columns automatically update when the corresponding column is updated';
    end if ;
    -- verify lcat name
    if new.lcat_name is distinct from old.lcat_name
    then       
        l_lcat_id = store.lcat_id(new.lcat_name);
        -- check for existing lcat name if new name is presented
        if l_lcat_id is null
        then
            -- do not allow the update
            raise exception 'Lookup Category name ''%'' does not exist.',new.lcat_name
            using hint = E'You must choose a valid Lookup Category name from devops.lookup_categories.\nYou may Update or Add a Lookup Category in devops.lookup_categories.';  
        end if;
    else
        l_lcat_id = old.lcat_id;
    end if;
    -- verify lcat source system name
    if new.lcat_src_name is distinct from old.lcat_src_name
    then
        -- confirm that new source system name already exists
        l_lcat_src_id = store.src_id(new.lcat_src_name);
        if l_lcat_src_id is null
        then
            -- do not allow the update
            raise exception 'Source ''%'' does not exist.',new.lcat_src_name
            using hint = E'You must choose a valid Source from devops.sources.\nYou may Update or Add a Source in devops.sources.';
        end if;
    else
        l_lcat_src_id = old.lcat_src_id;
    end if;
    -- verify ldat source system name
    if new.ldat_src_name is distinct from old.ldat_src_name
    then
        -- confirm that new source system name already exists
        l_ldat_src_id = store.ldat_src_id(new.ldat_src_name);
        if l_ldat_src_id is null
        then
            -- do not allow the update
            raise exception 'Source ''%'' does not exist.',new.ldat_src_name
            using hint = E'You must choose a valid Source from devops.sources.\nYou may Update or Add a Source in devops.sources.';
        end if;
    else
        l_ldat_src_id = old.ldat_src_id;
    end if;
    -- proceed with update if allowed  
    update chief.lookup_categories lcat
       set name = coalesce(new.lcat_name, old.lcat_name)
          ,description = coalesce(new.lcat_description,old.lcat_description)
          ,src_id = l_lcat_src_id
     where concat(new.lcat_name, new.lcat_description, new.lcat_src_name) 
           is distinct from
           concat(old.lcat_name, old.lcat_description, old.lcat_src_name)
       and lcat_id = old.lcat_id
    ;  
    update chief.lookup_data ldat
       set name = coalesce(new.ldat_name, old.ldat_name)
          ,description = coalesce(new.ldat_description,old.ldat_description)
          ,lcat_id = l_lcat_id
          ,src_id = l_ldat_src_id
     where concat(new.ldat_name, new.ldat_description, new.lcat_name, new.ldat_src_name) 
           is distinct from
           concat(old.ldat_name, old.ldat_description, old.lcat_name, old.ldat_src_name)
       and ldat_id = old.ldat_id
    ;
    -- provide final update results to User
    raise notice 'Lookup Data values: ldat_name = ''%'', ldat_description = ''%'', lcat_name = ''%'', lcat_src_name = ''%'', ldat_src_name = ''%''', new.ldat_name, new.ldat_description, new.lcat_name, new.lcat_src_name, new.ldat_src_name;              
    return new;
end;
$$;

comment on function devops.lookup_update() is 'Trigger Function on devops.lookup_data that performs a single update to chief.lookup_categories and/or to chief.lookup_data.';

