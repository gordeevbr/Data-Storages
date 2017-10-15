#!/usr/bin/env bash
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_branch1 -f branch1-data-update.sql
PGPASSWORD="ds_user_password" psql -U ds_user -d ds_branch2 -f branch2-data-update.sql