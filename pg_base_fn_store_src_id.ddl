/*  postgres - Base Module: Create function to return a unique src_id for a given Source name. - ddl  */

create function store.src_id(src_name_in text) 
returns uuid
language plpgsql security definer
as 
$$
declare
	l_return	uuid;
begin
	select src_id
	  into l_return
	  from chief.sources
	 where v_name = store.virtual_string(src_name_in)
	;
	return l_return;
end;
$$;

comment on function store.src_id(text) is 'Returns the Source ID (src_id) for a given Source Name as the name appears in devops.sources.src_name and in chief.sources.name.';
