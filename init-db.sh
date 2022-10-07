#!/bin/bash
echo "============================================="
echo "Docker init ${RDS_DB_NAME} image"
echo "============================================="
set -e
# First you need to enable postgis for all new databases. This will remove superuser requirement during db initialization
# http://stackoverflow.com/a/35209186/260480
echo "------> Add extensions"
psql -U ${POSTGRES_USER} -d template1 -c "CREATE EXTENSION IF NOT EXISTS unaccent;"
psql -U ${POSTGRES_USER} -d template1 -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;"

# Create primary database
echo "------> Creating user ${RDS_DB_USER}"
psql -U ${POSTGRES_USER} -c "CREATE USER ${RDS_DB_USER} WITH PASSWORD '${RDS_DB_PASSWORD}';"
psql -U ${POSTGRES_USER} -c "ALTER ROLE ${RDS_DB_USER} SET client_encoding TO 'utf8';"
psql -U ${POSTGRES_USER} -c "ALTER ROLE ${RDS_DB_USER} SET timezone TO 'UTC';"

echo "------> Creating databases \"${RDS_DB_NAME}\""
psql -U ${POSTGRES_USER} -c "CREATE DATABASE \"${RDS_DB_NAME}\" WITH OWNER ${RDS_DB_USER};"
psql -U ${POSTGRES_USER} -c "GRANT ALL PRIVILEGES ON DATABASE \"${RDS_DB_NAME}\" TO ${RDS_DB_USER};"