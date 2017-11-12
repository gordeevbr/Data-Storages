#!/usr/bin/env bash
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_central -f purge-storage.sql
