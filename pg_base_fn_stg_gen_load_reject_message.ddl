/*  postgres - Base Module: Create function to log error messages for rejected batch load items into stg.load_reject_log. - ddl  */

create function stg.gen_load_reject_message
      (function_name_in   chief.std_name
      ,identifier_in      text
      ,message_in         text
      ) 
returns void
language sql
as 
$$
    insert into stg.load_reject_log
           (rejecting_function
           ,identifier
           ,message
           )
    values (function_name_in
           ,identifier_in
           ,message_in
           )
    ;
$$;

comment on function stg.gen_load_reject_message(chief.std_name, text, text) is 'Function that inserts messages into stg.load_reject_log if errors occur during batch loads of data from stg schema to another schema.';
