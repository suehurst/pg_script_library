/*  postgres - BAR Module: Create Trigger Function to record captured DML statements and row data for tables participating in the BAR process. - ddl  */

create or replace function bar.dml_capture()
returns trigger
language plpgsql
as 
$$
declare 
    l_bart_id       uuid; 
    l_bare_id       uuid;
    l_rows_captured integer = 0; 
begin 
    raise notice 'Entered bar.dml_capture: trigger name=>% table=>%, action=>%'
	             ,tg_name, tg_table_schema || '.' || tg_table_name, tg_op ;	 
	-- Get id for table being processed.            
	select bart.bart_id 
	  into l_bart_id 
      from bar.captured_tables bart 
	 where bart.table_schema = tg_table_schema  
       and bart.table_name   = tg_table_name
       and bart.end_capture_ts  = 'infinity'::timestamp;              
    if not found then 
        raise exception 'BAR02e: Table %.% not currently being captured.',tg_table_schema,tg_table_name;
    end if;
    -- generate id for Events and Detail capture.
   	l_bare_id = bar.gen_id();    
    raise notice 'Inserting captured_dml_data (detail)';    
    if lower(tg_op) <> 'truncate' then
        insert into bar.captured_dml_data
              (bare_id
              ,bart_id
              ,row_event
              ,row_data
              )
        select l_bare_id 
              ,l_bart_id
              ,tg_op
              ,hstore(eff_row.*)
          from eff_row;
    end if;      
    get diagnostics l_rows_captured = row_count;
    raise notice 'Inserting captured_dml_events (header)'; 
    if l_rows_captured > 0 then 
 	    insert into bar.captured_dml_events
 	           (bare_id
 	           ,bart_id
 	           ,dml_item_cnt
 	           ,dml_event
 	           )
 	    values (l_bare_id
 	           ,l_bart_id
 	           ,l_rows_captured
 	           ,tg_op
 	           )
 	        on conflict (bare_id, bart_id) 
 	        do update 
 	              set dml_item_cnt = bar.captured_dml_events.dml_item_cnt
 	                          + excluded.dml_item_cnt;
 	end if;    
 	-- all done       
	return null; 
end;  
$$;

comment on function bar.dml_capture() is 'Trigger Function that inserts DML statments into bar.captured_dml_events and the resultant row data into bar.captured_dml_data for those tables participating in the BAR (Backup-Audit-Recover) process.';
