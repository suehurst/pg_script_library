/* populate bar.capture_tables for those tables participating in the BAR (Backup-Audit-Recover) process */
call bar.install('chief'::text,'lookup_categories'::text);
call bar.install('chief'::text,'lookup_data'::text);
call bar.install('chief'::text,'sources'::text);
