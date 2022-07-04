/*  postgres - Base Module: Create function to insert a single new Lookup data entity into chief.lookup_categories and chief.lookup_data. 
    To be used with UI for creating a new Lookup Category and/or Lookup Data entity. - ddl  
*/

create function store.create_lookup
      (lcat_name_in                  text
      ,lcat_description_in           text
      ,ldat_name_in                  text
      ,ldat_description_in           text
      ,source_in                     text
      ,orig_source_ident_in          text default null  
      ) 
returns boolean
language plpgsql security definer
as 
$$
declare
    k_this_function constant text = store.current_function();
	-- define working variables
	l_created_ok   boolean;
    l_src_id       chief.std_id;
    l_lcat_id      chief.std_id;
    l_src_name     chief.std_name;
begin
    -- get valid sources for lookups (assumes same source for lcat and for ldat)
    if source_in is not null
    then
        -- get the src_id if the source system already exists
        l_src_id = (select store.src_id(source_in));
        -- return error message if source is not found
        if l_src_id is null
        then
            -- do not allow the new entry
            raise exception 'LKUP0001: Source ''%'' does not exist.',source_in
            -- future:  offer to add new source from UI before proceeding
            using hint = E'You must choose a valid Source name from devops.sources.\nYou may Update or Add a Source in devops.sources.';  
        end if;
    elseif source_in = ''
    then -- do not allow the new entry
         raise exception 'LKUP002: Source ''%'' is an empty string.',name_in
         using hint = E'You must enter a valid Source name.'
         ; 
    else
        -- use the src_id for the UI that is calling this function
        l_src_id = (select store.src_id('UI - Create Lookup'));
    end if;   
    -- get the lcat_id if the lookup category already exists
    l_lcat_id = (select store.lcat_id(lcat_name_in));  
    -- create the lookup category if it does exist
    if l_lcat_id is null
    then 
	-- create a new category (assumes same source for lcat and for ldat)
	    insert into chief.lookup_categories
	           (name
    	       ,description
	           ,src_id
               ,orig_source_ident
	           )
	    values (lcat_name_in
	           ,lcat_description_in
	           ,l_src_id
               ,orig_source_ident_in
	           )
	    returning lcat_id into l_lcat_id
	    ;
	end if;
	-- create new lookup data entity  (assumes same source for lcat and for ldat)
	insert into chief.lookup_data
	       (lcat_id
	       ,name
	       ,description
	       ,src_id
	       ,orig_source_ident
	       )
	values (l_lcat_id
	       ,ldat_name_in
	       ,ldat_description_in
	       ,l_src_id
           ,orig_source_ident_in
           )
	on conflict do nothing
	;
    -- see if the lookup exists. If so then report True for created. While this may not physically be the case ( it could
	-- have already existed) the state of the database is consistent as at the end of the process the desired data existed.  
    l_created_ok = EXISTS (select null
                             from chief.lookup_data ldat
                            where ldat.lcat_id = l_lcat_id
                              and ldat.v_name = store.virtual_string(ldat_name_in)
                           );
                   raise notice 'LKUP003 l_created_ok after trying to insert a new lookup data entity is: %', l_created_ok::text;
    if not l_created_ok
    then
        -- still not created, but does the requested category exist
        if EXISTS (select null
                     from chief.lookup_categories lcat
                    where 1=1
                      and lcat.v_name = store.virtual_string(lcat_name_in)
                  )
        then
            -- the parent category exists but unable to create lookup_data --- but why???
            perform chief.gen_load_reject_message
                   (k_this_function
   		  		   ,ldat_name_in
   		    	   ,format ('LKUP004: Could not create lookup data, but condition UNKNOWN'
                           ,coalesce(ldat_name_in)
                           )
                   );
        else
            -- could not create lookup_data since lookup_category didn't exist. Inform user;
            perform chief.gen_load_reject_message
                   (k_this_function
   		  		   ,ldat_name_in
   				   ,format ('LKUP005: Could not create lookup data as category ''%'' does not exist'
                           ,coalesce(lcat_name_in)
                           )
                   );
        end if ;
    end if ;
    raise notice 'LKUP005 l_created_ok returned by store.create_lookup (......) is : %', l_created_ok;
	-- and exit.
	return l_created_ok;
end;
$$;

comment on function store.create_lookup(text, text, text, text, text, text) is 'Creates a single Lookup Category and/or Lookup Data element in devops.lookup, chief.lookup_categories and chief.lookup_data.';
