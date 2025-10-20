#!/bin/bash
set -e

# This script runs on the PRIMARY server to set up replication

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create replication user
    CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD '$(cat /run/secrets/postgres_replication_password)';

    -- Grant necessary permissions
    GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO replicator;
EOSQL

echo "Primary replication user created successfully"
