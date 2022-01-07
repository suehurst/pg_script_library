/*  postgres - Base Module: Create function to return a unique lcat_id for a given Lookup Category name. - ddl  */

create function store.lcat_id(lcat_name_in text) 
returns uuid
language plpgsql security definer
as 
$$
declare
	l_return	uuid;
begin
	select lcat_id
	  into l_return
	  from chief.lookup_categories
	 where v_name = store.virtual_string(lcat_name_in)
	;
	return l_return;
end;
$$;

comment on function store.lcat_id(text) is 'Returns the Lookup Category ID (lcat_id) for a given Lookup Category Name as the name appears in devops.lookup.lcat_name and in chief.lookup_categories.name.';
