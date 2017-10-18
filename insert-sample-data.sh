#!/usr/bin/env bash
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_branch1 -f common-data.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_branch2 -f common-data.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_restore -f common-data.sql