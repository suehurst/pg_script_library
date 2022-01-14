/*  postgres - Base Module: Create Domain std_date for formatting interval timestamps to the minute using a 24 hour clock. - ddl  */

-- drop domain chief.std_date;
create domain chief.std_date
    as timestamp with time zone
    default date_trunc('minute'::text, now())
;

comment on domain chief.std_date is 'Typically used for formatting interval timestamps. Standard date formatted to the minute ''YYYY-MM-DD HH24:MI''.';
