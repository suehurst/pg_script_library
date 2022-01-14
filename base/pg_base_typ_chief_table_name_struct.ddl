/*  postgres - Base Module: Create Type table_name_struct to be used by functions to build table names dynamically. - ddl  */

-- drop type chief.table_name_struct;
create type chief.table_name_struct as
(full_name character varying(128),table_schema name,table_name name,parm_string character varying(128))
;

comment on type chief.table_name_struct is 'Type used by several functions to build table names dynamically.';

