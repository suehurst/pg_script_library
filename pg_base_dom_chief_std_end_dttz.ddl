/*  postgres - Base Module: Create Domain std_end_dttz to post the timestamp of a row that will be decommissioned from inclusion in ongoing processes. - ddl  */

-- drop domain chief.std_end_dttz;
create domain chief.std_end_dttz
    as timestamp with time zone
    default 'infinity'::timestamp with time zone
    not null
;

comment on domain chief.std_end_dttz is 'Timestamp for decommissioning an entity from inclusion in ongoing processes after that date/time.';
