/*  postgres - Base Module: Create function to return a unique ldat_id for a given Lookup Category and Lookup_data name. - ddl  */

create function store.ldat_id
      (lcat_name_in text
      ,ldat_name_in text
      ) 
returns uuid
language plpgsql security definer
as 
$$
declare
	l_return	uuid;
begin
	select ldat.ldat_id
	  into l_return
	  from chief.lookup_categories lcat
          ,chief.lookup_data ldat
	 where lcat.v_name = store.virtual_string(lcat_name_in)
       and ldat.v_name = store.virtual_string(ldat_name_in)
	;
	return l_return;
end;
$$;

comment on function store.ldat_id(text, text) is 'Returns the Lookup Data ID (ldat_id) for a given Lookup Category Name and Lookup Data Name as they appear in devop.lookup.lcat_name and devops.lookup.ldat_name.';
