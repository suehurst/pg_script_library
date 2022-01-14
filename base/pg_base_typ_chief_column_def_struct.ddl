/*  postgres - Base Module: Create Type column_def_struct to be used by functions to build column definitions dynamically. - ddl  */

-- drop type chief.column_def_struct;
create type chief.column_def_struct 
as
(column_name name,data_desc text)
;

comment on type chief.column_def_struct is 'Type used by several functions to build column definitions dynamically.';
