#!/usr/bin/env bash

set -e

# Database where jobs are persisted
if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "ERROR: Missing environment variables. Set value for '$POSTGRES_PASSWORD'."
  exit 1
fi

echo "Creating rd_jrd_ref_data Database . . ."

# TODO - The password only works if hardcoded in when creating roles
psql -v ON_ERROR_STOP=1 --username postgres --set USERNAME=rd_sys_ref_data --set PASSWORD=${POSTGRES_PASSWORD} <<-EOSQL
  CREATE ROLE :USERNAME WITH LOGIN PASSWORD 'rd_jrd_ref_data';
  CREATE DATABASE rd_jrd_ref_data
    WITH OWNER = :USERNAME
    ENCODING = 'UTF-8'
    CONNECTION LIMIT = -1;
EOSQL

echo "Done creating Database rd_jrd_ref_data."
