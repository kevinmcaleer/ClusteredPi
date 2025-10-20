# Hardened PostgreSQL Deployment with Docker Swarm

This setup provides a secure, replicated PostgreSQL deployment with:
- Docker Secrets for credential management
- IP-based access restrictions (192.168.x.x only)
- Security hardening with minimal capabilities
- Health checks and automatic failover
- Resource limits

## Prerequisites

- Docker Swarm initialized
- Nodes `dev03` and `dev04` available in the swarm

To verify your nodes:

```bash
docker node ls
```

Make sure `dev03` and `dev04` are in the list and in Ready status.

**Note**: The deployment is configured to run exclusively on `dev03` and `dev04` with one instance per node.

## Step 1: Label the Nodes

First, label `dev03` and `dev04` to allow PostgreSQL deployment:

```bash
# Label the nodes
docker node update --label-add postgres=true dev03
docker node update --label-add postgres=true dev04

# Verify the labels were applied
docker node inspect dev03 --format '{{.Spec.Labels}}'
docker node inspect dev04 --format '{{.Spec.Labels}}'
```

## Step 2: Create Docker Secrets

Create secrets for the PostgreSQL username and password:

```bash
# Create the username secret
echo "kev" | docker secret create postgres_user -

# Create the password secret (replace 'your_secure_password' with a strong password)
echo "your_secure_password" | docker secret create postgres_password -
```

**Important**: Never commit secrets to git. Store them securely.

### Verify secrets were created:

```bash
docker secret ls
```

## Step 3: Deploy the Stack

Deploy the PostgreSQL service to the swarm:

```bash
cd /Users/kev/Web/ClusteredPi/stacks/postgresql
docker stack deploy -c docker-compose-swarm.yml postgres
```

## Step 4: Verify Deployment

Check the services are running:

```bash
# Check service status
docker service ls

# Check service logs
docker service logs postgres_postgres

# Check which nodes are running replicas (should show dev03 and dev04)
docker service ps postgres_postgres
```

You should see output showing one replica on `dev03` and one on `dev04`.

## Step 5: Test Connection

From a 192.168.x.x address:

```bash
# Get the secret values for connection
PGUSER=$(docker secret inspect postgres_user --format='{{.Spec.Data}}' | base64 -d)
PGPASS=$(docker secret inspect postgres_password --format='{{.Spec.Data}}' | base64 -d)

# Connect to PostgreSQL
psql -h 192.168.2.X -p 5433 -U $PGUSER -d pagecount
```

## Security Features

### 1. Docker Secrets
- Credentials stored encrypted in Swarm
- Only accessible to authorized containers
- Not visible in environment variables or logs

### 2. Network Restrictions
- `pg_hba.conf` restricts connections to 192.168.0.0/16
- All other IPs explicitly rejected
- SCRAM-SHA-256 authentication (stronger than MD5)

### 3. Container Hardening
- Minimal capabilities (dropped ALL, added only necessary ones)
- `no-new-privileges` prevents privilege escalation
- Resource limits prevent resource exhaustion
- Read-only where possible with tmpfs for temporary files

### 4. High Availability
- 2 replicas pinned to `dev03` and `dev04` with `max_replicas_per_node: 1`
- Automatic restart on failure
- Health checks with pg_isready
- Rolling updates with rollback on failure
- Spread placement preference ensures instances are distributed across both nodes

## Configuration Files

### pg_hba.conf
Controls client authentication and IP restrictions.

### postgresql.conf
Performance and security tuning:
- SCRAM-SHA-256 password encryption
- Connection logging
- Slow query logging (>1s)
- Replication settings

## Updating Secrets

To rotate credentials:

```bash
# Remove old secret
docker secret rm postgres_password

# Create new secret
echo "new_secure_password" | docker secret create postgres_password -

# Update the service (forces recreation)
docker service update --secret-rm postgres_password postgres_postgres
docker service update --secret-add postgres_password postgres_postgres
```

## Scaling

To change the number of replicas:

```bash
docker service scale postgres_postgres=3
```

## Backup

Backup the PostgreSQL data:

```bash
# Find the node running the primary
docker service ps postgres_postgres

# On that node, backup the volume
docker run --rm -v postgres_postgres_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/postgres_backup_$(date +%Y%m%d).tar.gz /data
```

## Troubleshooting

### Check if IP restrictions are working:

```bash
# From allowed IP (192.168.x.x) - should succeed
psql -h <postgres_ip> -p 5433 -U kev -d pagecount

# From disallowed IP - should fail with authentication error
```

### View logs for authentication attempts:

```bash
docker service logs postgres_postgres | grep -i "connection\|authentication"
```

### Check secrets are mounted correctly:

```bash
# Get container ID
docker ps | grep postgres

# Check secret files exist
docker exec <container_id> ls -la /run/secrets/
```

## Production Considerations

1. **SSL/TLS**: Enable SSL by setting `ssl = on` in postgresql.conf and mounting certificates
2. **Backup Strategy**: Implement automated backups with pg_dump or WAL archiving
3. **Monitoring**: Add Prometheus exporters for metrics
4. **Replication**: For true HA, consider PostgreSQL streaming replication or Patroni
5. **Volume Driver**: Use distributed volume drivers (like GlusterFS) for data persistence across nodes

## Rollback

To remove the stack:

```bash
docker stack rm postgres

# Optionally remove secrets
docker secret rm postgres_user postgres_password
```

## Notes

- The current setup deploys 2 replicas but they are NOT in streaming replication mode
- Each replica has its own data volume
- For true master-slave replication, additional configuration is needed
- The `replicas: 2` provides redundancy if one node fails, not data replication
