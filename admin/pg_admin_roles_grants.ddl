/*  postgres - Admin Module: Create basic roles and grants for the database. - ddl  */


# add login roles  
create role ${DBNAME}_admin login nosuperuser inherit nocreatedb nocreaterole noreplication;
create role ${DBNAME}_user login nosuperuser inherit nocreatedb nocreaterole noreplication;

# add group roles
create role read nosuperuser inherit nocreatedb nocreaterole noreplication;
create role write nosuperuser inherit nocreatedb nocreaterole noreplication;

# Grant rights to ${DBNAME}_admin and ${DBNAME}_user
grant read, write to ${DBNAME}_admin;
grant read to ${DBNAME}_user;
grant select on all tables in schema public to ${DBNAME}_admin;
grant select on all tables in schema public to ${DBNAME}_user;


