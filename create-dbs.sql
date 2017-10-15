---User Dropping/Creation---

reassign owned by ds_user to postgres;

drop user if exists ds_user;
create user ds_user with password 'ds_user_password';

---DB Dropping/Creation---

drop database if exists ds_branch1;
drop database if exists ds_branch2;
drop database if exists ds_central;
drop database if exists ds_restore;

create database ds_branch1 with owner ds_user;
create database ds_branch2 with owner ds_user;
create database ds_central with owner ds_user;
create database ds_restore with owner ds_user;