/*  postgres - Base Module: Create function to safely update lookup categories and data in devops.lookup view. - ddl  */

-- drop function devops.invalid_col_update(text, text, text);
create function devops.invalid_col_update(col_name_in text, old_value_in text, new_value_in text) 
returns text
language sql stable strict
as 
$$
    select case when old_value_in is distinct from new_value_in then ','||col_name_in else '' end;
$$;

comment on function devops.invalid_col_update(text, text, text) is 'Function to prevent direct updates to specified columns:  ''_id'', ''v-name'', ''create_dttz'' values. Function is called by all update trigger functions.';
