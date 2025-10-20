#!/bin/bash
set -e

DATADIR=/var/lib/postgresql/data

# Wait for primary to be ready
echo "Waiting for primary to be ready..."
until pg_isready -h postgres-primary -p 5432 -U "$(cat /run/secrets/postgres_user)" 2>/dev/null; do
  echo "Primary not ready yet, waiting..."
  sleep 2
done

echo "Primary is ready!"

# Check if this is first run (no data directory)
if [ ! -s "$DATADIR/PG_VERSION" ]; then
  echo "First run - creating base backup from primary..."
  rm -rf $DATADIR/*
  mkdir -p $DATADIR

  # Create base backup using replication user
  PGPASSWORD="$(cat /run/secrets/postgres_replication_password)" \
  pg_basebackup -h postgres-primary -D $DATADIR -U replicator -v -P -W -R

  echo "Base backup complete - replica ready to start"
fi

# Use the official postgres entrypoint with our custom configs
exec docker-entrypoint.sh postgres \
  -c config_file=/etc/postgresql/postgresql.conf \
  -c hba_file=/etc/postgresql/pg_hba.conf
