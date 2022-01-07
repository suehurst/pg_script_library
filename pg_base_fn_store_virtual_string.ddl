/*  postgres - Base Module: Create function to return a lower case string value for creating unique business keys. - ddl  */

create or replace function store.virtual_string(string_in text)
returns text 
language sql
security definer
immutable
as 
$$
    select regexp_replace (lower(unaccent(string_in)),'[^0-9a-z]','','g');
$$;

comment on function store.virtual_string(text) is 'Returns the lower case value of a string limited to [^0-9a-z] characters. Used for creating unique business keys.';
