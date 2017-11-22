#!/usr/bin/env bash
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_mart -f purge-storage.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_mart -f migrate-simple.sql