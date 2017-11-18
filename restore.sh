#!/usr/bin/env bash
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_central -f purge-restoration.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_central -f restore.sql -v target_branch=$1 -v target_migration=$2