/* postgres - Base Module: Create Trigger sources_iur_trg to execute procedure devops.sources_update(). - ddl  */

create trigger sources_iur_trg instead of update on devops.sources for each row execute procedure devops.sources_update();

comment on trigger sources_iur_trg on devops.sources is 'Trigger executes procedure devops.sources_update()';
