/*  postgres - Base Module: Create Domain std_description for describing a row to help understand its intended usage. - ddl  */

-- drop domain chief.std_description;
create domain chief.std_description
    as text
;
    
comment on domain chief.std_description is 'Typically used for describing a row to help understand its intended usage.';
