CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER foreign_branch1
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'ds_branch1');

CREATE SERVER foreign_branch2
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'ds_branch2');

CREATE USER MAPPING FOR ds_user
  SERVER foreign_branch1
  OPTIONS (user 'ds_user', password 'ds_user_password');

CREATE USER MAPPING FOR ds_user
  SERVER foreign_branch2
  OPTIONS (user 'ds_user', password 'ds_user_password');

IMPORT FOREIGN SCHEMA public FROM SERVER foreign_branch1 INTO branch1_schema;
IMPORT FOREIGN SCHEMA public FROM SERVER foreign_branch2 INTO branch2_schema;