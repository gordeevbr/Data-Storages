#!/usr/bin/env bash
psql -U postgres -f create-dbs.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_central -f create-tables.sql