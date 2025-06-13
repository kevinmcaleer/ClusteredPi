# Run this script every 30 minutes to rebalance the Docker Swarm cluster.

```bash
*/30 * * * * /usr/local/bin/swarm-rebalance.sh >> /var/log/swarm-rebalance.log 2>&1
```
