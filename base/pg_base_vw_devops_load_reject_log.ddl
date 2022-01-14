/*  postgres - Base Module: Create view of batch load Rejects in stg.load_reject_log. - ddl  */

create view devops.load_reject_log 
as
select lrl.lrl_id
      ,lrl.rejecting_function
      ,lrl.identifier
      ,lrl.message
      ,lrl.db_user
      ,lrl.reject_dttz
  from stg.load_reject_log lrl
;

comment on view devops.load_reject_log is 'Alias: LRL - List of specific error messages to assist with batch loading data from staging tables in the stg schema to data storage tables in production schemas.';
