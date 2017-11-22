#!/usr/bin/env bash
psql -U postgres -f create-dbs.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_central -f create-tables.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_central -f connect-foreign-db.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_mart -f connect-foreign-db-mart.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_mart -f view.sql