/*  postgres - BAR Module: Create Procedure to populate table bar.captured_tables and to generate triggers on the target tables to capture BAR statements and data. - ddl  */

create or replace procedure bar.install
      (table_schema_in name 
      ,table_name_in   name
      )
language plpgsql
/*
  The BAR functionality depends installation of 4 DML triggers. It requires 4 triggers since one (Truncate) 
  does not provide the detail rows removed from the table at all. The others (Delete, Insert, Update) are 
  required separately since Postgres only permits a single action for the 'referencing table' option. That 
  being the central component of the BAR. 
  
  This routine generates those triggers when the BAR is installed. These table names consist of TABLE_NAME 
  and suffix, where the prefix is derived the the type trigger as:
     _ads ==> after delete statement
     _ais ==> after insert statement
     _aus ==> after update statement
     _ats ==> after truncate statement 
*/  
as 
$$
declare  
    k_drop_trigger constant text = ' drop trigger if exists %I on  %I.%I ';
    k_base_trigger constant text = ' create trigger %I after %s on %I.%I ';
    k_referencing  constant text = ' referencing %s table as eff_row';
    k_run_function constant text = ' for each statement'
                                   ' execute function bar.dml_capture()';
                                
    k_op           constant text[] = array['delete','insert','update','truncate'];                             
    k_ref          constant text[] = array['old','new','old' ,null];
    k_trg          constant text[] = array['_ads','_ais','_aus','_ats'];

    l_ddl_stmt     text; 
begin 
    -- If needed, set the date/time to end the capture of BAR data for a table listed in bar.captured_tables.
    update bar.captured_tables
	   set end_capture_ts = timezone('utc'::text, transaction_timestamp())
	 where (table_schema, table_name) = (table_schema_in, table_name_in)
       and end_capture_ts = 'infinity'::timestamp;
    -- Enroll a table into the BAR process.   
	insert into bar.captured_tables(table_schema, table_name)
	values (table_schema_in, table_name_in); 	
	-- Create triggers on the newly enrolled table to capture statements and row data upon insert, update, delete. Capture statement for truncate.    
	for indx in 1 .. array_length(k_op, 1)
	    loop
	 	    l_ddl_stmt = format(k_drop_trigger, table_name_in || k_trg[indx]
	                           ,table_schema_in
	                           ,table_name_in
	                           );
	        raise notice '%',l_ddl_stmt; 
	        execute l_ddl_stmt;    
	        l_ddl_stmt = format(k_base_trigger, table_name_in || k_trg[indx]
	                           ,k_op[indx]
	                           ,table_schema_in
                               ,table_name_in
	                           ); 
	        if k_op[indx] <> 'truncate' 
	        then
	            l_ddl_stmt = l_ddl_stmt || format(k_referencing,k_ref[indx]) ;
	        end if; 
	        l_ddl_stmt = l_ddl_stmt || k_run_function; 
	        raise notice '%',l_ddl_stmt; 
	        execute l_ddl_stmt;
	    end loop;      
end; 
$$;

comment on procedure bar.install(name,name) is 'Procedure generates 4 triggers when the BAR is installed. The trigger names consist of table_name and suffix, where the suffix is derived the the type trigger as: _ads ==> after delete statement, _ais ==> after insert statement, _aus ==> after update statement and _ats ==> after truncate statement.';
