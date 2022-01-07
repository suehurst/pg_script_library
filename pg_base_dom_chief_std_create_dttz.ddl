/*  postgres - Base Module: Create Domain std_create_dttz, the timestamp of row creation in a table. - ddl  */

-- drop domain chief.std_create_dttz;
create domain chief.std_create_dttz
    as timestamp with time zone
    default now()
    not null
;

comment on domain chief.std_create_dttz is 'Timestamp of row creation in a table. Useful for time series analysis.';
