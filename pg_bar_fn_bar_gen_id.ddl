/*  postgres - BAR Module: Create function to generate a unique UUID using md5(date,pid,query). This ID links a DML statement to the rows of data it captured. - ddl  */

create or replace function bar.gen_id()
returns  uuid
language sql
/*
  Generate a UUID for the current transaction. While the declaration of immutable is actually lying 
  to Postgres in this case is ok. Actually it should be Stable. But we are only ever interested in 
  the current transaction and statement and therefore 'constant forever' thus effectively immutable.
  Also, since the function is defined as Immutable Postgres allows using it as the source of generated
  columns.  Do not use this function outside of creating UUIDs for the BAR.
*/ 
as 
$$
    select md5(concat( timezone('utc'::text, transaction_timestamp())::text
                     , pg_backend_pid()::text
                     , current_query()::text
                     )
              )::uuid
$$;  

comment on function bar.gen_id(pid_in text, query_in text) is 'Function that encodes a query using md5(date,pid,query) of an insert, update or delete statement. It is called by the bar.bar_capture_tables() function as part of the BAR (Backup-Audit-Recovery) process.';
