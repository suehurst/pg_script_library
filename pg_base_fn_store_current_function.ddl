/*  postgres - Base Module: Create function to return the name of the routine calling it. - ddl  */

create function store.current_function(return_parm_list_in boolean default false) 
returns text
    language plpgsql
as 
$$
    declare
        l_stack text;
        nl      text = E'\n';
        l_eol   integer;
begin
   /*-----------------------------------------------------------------------------------------------------------------------
     We're looking for the function asking for it's name. This will be the 3rd line in the stack:
       1st line in the GET DIAGNOSTICS function itself (yea it's a function)
       2nd is this function itself.
       3rd is the function making the request.
   -----------------------------------------------------------------------------------------------------------------------*/
    GET DIAGNOSTICS l_stack = PG_CONTEXT;
    for i in 1..2
    loop
        -- find end-of-line and throw the line away
        l_eol = position (nl in l_stack);
        l_stack = substring(l_stack,l_eol+1);
    end loop;

    if return_parm_list_in
    then
        l_stack = REGEXP_REPLACE(l_stack,'^.*function\s+(.+\(.*\)).*$','\1');
    else
        l_stack = REGEXP_REPLACE(l_stack,'^.*function\s+(.+)\(.*$','\1');
    end if ;
    return l_stack;
end ;
$$;

comment on function store.current_function(boolean) is 'Function returns the name of the routine calling it. Tho optional boolean parameter ''return_parm_list_in'' indicates whether the parameter type of the calling function should be return. Default: False - do not return parameter types.';
