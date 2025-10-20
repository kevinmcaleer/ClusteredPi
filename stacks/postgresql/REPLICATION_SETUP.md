# PostgreSQL Streaming Replication Setup

This setup provides true PostgreSQL streaming replication with:
- **Primary server** on dev03 (port 5433) - Read/Write
- **Replica server** on dev04 (port 5434) - Read-only
- Automatic failover capability
- Real-time data synchronization

## Architecture

```
┌─────────────────────┐
│   dev03 (PRIMARY)   │
│   Port: 5433        │
│   Read/Write        │
└──────────┬──────────┘
           │
           │ WAL Streaming
           │ Replication
           ▼
┌─────────────────────┐
│  dev04 (REPLICA)    │
│   Port: 5434        │
│   Read-Only         │
└─────────────────────┘
```

## Prerequisites

Remove the old non-replicated stack:

```bash
docker stack rm postgres
docker volume rm postgres_postgres_data
sleep 10
```

## Step 1: Create Replication Secret

In addition to the existing postgres_user and postgres_password secrets, create a replication password:

```bash
# Create replication password (use a strong password)
echo "your_replication_password" | docker secret create postgres_replication_password -

# Verify all secrets exist
docker secret ls | grep postgres
```

You should see:
- postgres_user
- postgres_password
- postgres_replication_password

## Step 2: Label Nodes

Ensure dev03 and dev04 have proper hostnames:

```bash
# Check current node hostnames
docker node ls

# If needed, update hostnames to match exactly "dev03" and "dev04"
docker node update --label-add postgres=true <dev03-node-id>
docker node update --label-add postgres=true <dev04-node-id>
```

## Step 3: Deploy Replication Stack

```bash
cd ~/ClusteredPi/stacks/postgresql

# Deploy the replication stack
docker stack deploy -c docker-compose-replication.yml postgres

# Watch services start (primary first, then replica)
watch -n 2 'docker service ls | grep postgres'
```

## Step 4: Verify Replication

### Check Services

```bash
# Both services should show 1/1
docker service ls | grep postgres

# Check which nodes they're on
docker service ps postgres_postgres_primary
docker service ps postgres_postgres_replica
```

### Verify Replication Status on Primary

```bash
# Get primary container
docker ps | grep postgres-primary

# Connect to primary
docker exec -it <primary-container-id> psql -U $(docker secret inspect postgres_user --format='{{.Spec.Data}}' | base64 -d) -d kevsrobots_cms

# Check replication status
SELECT * FROM pg_stat_replication;
```

You should see one row showing the replica connection.

### Verify Replica is Following

```bash
# Get replica container
docker ps | grep postgres-replica

# Connect to replica
docker exec -it <replica-container-id> psql -U $(docker secret inspect postgres_user --format='{{.Spec.Data}}' | base64 -d) -d kevsrobots_cms

# Check recovery status (should show true)
SELECT pg_is_in_recovery();
```

Should return `t` (true), meaning it's in recovery/replica mode.

## Step 5: Test Replication

### On Primary (dev03:5433):

```sql
-- Create a test table
CREATE TABLE replication_test (
    id SERIAL PRIMARY KEY,
    test_data TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert test data
INSERT INTO replication_test (test_data) VALUES ('Test from primary');
```

### On Replica (dev04:5434):

```sql
-- Query the replicated data (should appear within seconds)
SELECT * FROM replication_test;
```

If you see the data, replication is working!

## Connection Details

### For pgAdmin4:

**Primary (Read/Write)**:
- Host: `192.168.2.3` (dev03)
- Port: `5433`
- Database: `kevsrobots_cms`
- Username: _(from postgres_user secret)_
- Password: _(from postgres_password secret)_

**Replica (Read-Only)**:
- Host: `192.168.2.4` (dev04)
- Port: `5434`
- Database: `kevsrobots_cms`
- Username: _(same as primary)_
- Password: _(same as primary)_

### Retrieve Credentials:

```bash
echo "Username: $(docker secret inspect postgres_user --format='{{.Spec.Data}}' | base64 -d)"
echo "Password: $(docker secret inspect postgres_password --format='{{.Spec.Data}}' | base64 -d)"
```

## Monitoring

### Check Replication Lag:

On primary:

```sql
SELECT
    client_addr,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    sync_state,
    pg_wal_lsn_diff(sent_lsn, replay_lsn) AS replication_lag_bytes
FROM pg_stat_replication;
```

### View Logs:

```bash
# Primary logs
docker service logs postgres_postgres_primary --tail 50 --follow

# Replica logs
docker service logs postgres_postgres_replica --tail 50 --follow
```

## Failover (Manual)

If dev03 (primary) fails:

1. **Promote replica to primary:**

```bash
# Connect to replica container
docker exec -it <replica-container-id> bash

# Promote to primary
su postgres -c "pg_ctl promote -D /var/lib/postgresql/data/pgdata"
```

2. **Update application to connect to dev04:5434**

3. **When dev03 recovers, rebuild as new replica**

## Troubleshooting

### Replica won't start:

```bash
# Check replica logs
docker service logs postgres_postgres_replica

# Common issues:
# 1. Primary not ready - wait longer
# 2. Network connectivity - check postgres_network
# 3. Replication password wrong - recreate secret
```

### Replication stopped:

```bash
# On primary, check replication slots
SELECT * FROM pg_replication_slots;

# If inactive, restart replica
docker service update --force postgres_postgres_replica
```

### Reset and start over:

```bash
docker stack rm postgres
docker volume rm postgres_postgres_primary_data postgres_postgres_replica_data postgres_postgres_archive
sleep 10
docker stack deploy -c docker-compose-replication.yml postgres
```

## Notes

- **Primary** is on dev03 - all writes go here
- **Replica** is on dev04 - read-only, synchronized automatically
- Replica lag is typically < 1 second on local network
- If primary fails, replica must be manually promoted
- After promotion, old primary must be rebuilt as new replica
