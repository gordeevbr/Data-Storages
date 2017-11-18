CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER foreign_branch1
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'ds_branch1');

CREATE SERVER foreign_branch2
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'ds_branch2');

CREATE SERVER foreign_restore
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'ds_restore');

CREATE USER MAPPING FOR ds_user
  SERVER foreign_branch1
  OPTIONS (user 'ds_user', password 'ds_user_password');

CREATE USER MAPPING FOR ds_user
  SERVER foreign_branch2
  OPTIONS (user 'ds_user', password 'ds_user_password');

CREATE USER MAPPING FOR ds_user
  SERVER foreign_restore
  OPTIONS (user 'ds_user', password 'ds_user_password');

IMPORT FOREIGN SCHEMA public FROM SERVER foreign_branch1 INTO branch1_schema;
IMPORT FOREIGN SCHEMA public FROM SERVER foreign_branch2 INTO branch2_schema;
IMPORT FOREIGN SCHEMA public FROM SERVER foreign_restore INTO restore_schema;