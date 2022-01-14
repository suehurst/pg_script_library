-- confirm database name
select 'Database Name:  '||current_catalog
       ||', '||' Hostname:  '||boot_val
	   ||', '||' Host IP Address:  '||inet_server_addr()
	   ||', '||' Port:  '||inet_server_port()     "DB Server Info"	   
  from pg_catalog.pg_settings
 where name='listen_addresses'
;
