/* postgres - Base Module: Create Trigger lookup_iur_trg to execute procedure devops.lookup_update(). - ddl  */

create trigger lookup_iur_trg instead of update on devops.lookup for each row execute procedure devops.lookup_update();

comment on trigger lookup_iur_trg on devops.lookup is 'Trigger lookup_iur_trg upon update to devops.lookup to modify values in chief.lookup_categories and/or chief.lookup_data.';
