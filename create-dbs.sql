---User and DB Dropping/Creation---
drop owned by ds_user cascade;

\c ds_branch1;
drop owned by ds_user cascade;

\c ds_branch2;
drop owned by ds_user cascade;

\c ds_central;
drop owned by ds_user cascade;

\c ds_restore;
drop owned by ds_user cascade;

\c postgres;

drop database if exists ds_branch1;
drop database if exists ds_branch2;
drop database if exists ds_central;
drop database if exists ds_restore;

drop user if exists ds_user;
create user ds_user with superuser encrypted password 'ds_user_password';

create database ds_branch1 with owner ds_user;
create database ds_branch2 with owner ds_user;
create database ds_central with owner ds_user;
create database ds_restore with owner ds_user;