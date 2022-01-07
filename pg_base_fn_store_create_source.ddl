/*  postgres - Base Module: Create function to insert a single new Source into chief.sources. To be used with UI for creating a new Source. - ddl  */

create function store.create_source 
      (name_in               text
      ,description_in        text
      ,orig_source_ident_in  text default null
      ) 
returns boolean
language plpgsql security definer
as 
$$
declare
    k_this_function constant text = store.current_function();
	-- define working variables
	l_created_ok   boolean;
begin	
	-- create a source system if not already exists
	insert into chief.sources 
       	   (name
	       ,description
           ,orig_source_ident
	       )
	values (name_in
	       ,description_in
           ,orig_source_ident_in
	       )
	on conflict do nothing
	;	
    -- see if the source exists. If so then report True for created. While this may not physically be the case ( it could
	-- have already existed) the state of the database is consistent as at the end of he process the desired data existed.  
    l_created_ok = exists (select null
                             from chief.sources src
                            where 1=1
                              and src.v_name = store.virtual_string(name_in)
                           );
                   raise notice 'SRC10 l_created_ok after trying to insert a new source is: %', l_created_ok::text;
    if not l_created_ok
    then
        -- unable to create source --- but why???
        perform chief.gen_load_reject_message
               (k_this_function
   		  	   ,name_in
   		       ,format ('SRC20: Could not create source, but condition UNKNOWN'
                       ,coalesce(name_in)
                       )
               );
    end if ;
    raise notice 'SRC30 l_created_ok returned by store.create_source (%, %, %) is : %', name_in, description_in, orig_source_ident_in, l_created_ok;
	-- and exit.
	return l_created_ok;
end;	
$$;

comment on function store.create_source(text, text, text) is 'Creates a single source in devops.sources and chief.sources.';
