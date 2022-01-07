/*  postgres - BAR Module: Overloaded Procedure to populate table bar.captured_tables and to generate triggers on the target tables to capture BAR statements and data. - ddl  */

create or replace procedure bar.install
      (table_name_in text)
language plpgsql
as 
$$
declare 
    l_pos      integer;
begin        
	l_pos = position ('.' in table_name_in); 
	if l_pos > 0 then
	    call bar.install(substr(table_name_in,1,l_pos-1), substr(table_name_in,l_pos+1));
	else 
	    raise exception E'BAR01e : Install, invalid table name or format %,\n'
                          'must be schema.table_name', table_name_in;
	end if; 
end ;  
$$;

comment on procedure bar.install(text) is 'Overloaded procedure that accepts the table name input parameter in the form schema_name.table_name. Procedure calls procedure bar.install(table_schema_in, table_name_in).';
