/*  postgres - Base Module: Create trigger function to safely update sources in devops.sources view. To be used with UI for updating a Source. - ddl  */

-- drop function devops.sources_update();
create function devops.sources_update()
returns trigger
language plpgsql
as 
$$
declare
    k_invalid_col_msg  text = E'SRC10: Invalid column reference for update.  _ID and v_ and create_dttz columns cannot be updated. Update attempts to update columns\n\t%' ;
    l_invalid_col_list text = '';
begin
     -- raise info 'Enter Trigger Function devops.sources_update() for old name = %',old.src_v_name::text;
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('src_v_name'::text,new.src_v_name::text,old.src_v_name::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('src_id'::text,new.src_id::text,old.src_id::text);
     l_invalid_col_list = l_invalid_col_list || devops.invalid_col_update('src_create_dttz'::text,new.src_create_dttz::text,old.src_create_dttz::text);
    if length(l_invalid_col_list) > 0
    then
        raise exception '% %',k_invalid_col_msg,trim(l_invalid_col_list,',')
              using hint = E'To update _ids use the business key of entity.\nv_ columns automatically update when the corresponding column is updated';
    end if ;
    update chief.sources  src
       set name = coalesce(new.src_name, old.src_name)
          ,description = coalesce(new.src_description,old.src_description)
          ,orig_source_ident = coalesce(new.orig_source_ident,old.orig_source_ident)
     where concat(new.src_name,new.src_description,new.orig_source_ident) 
        is distinct from
           concat(old.src_name,old.src_description,old.orig_source_ident)
       and lcat.lcat_id = old.lcat_id;
    return new;
end ;
$$;

comment on function devops.sources_update() is 'Trigger Function on devops.sources that performs updates to chief.sources.';
