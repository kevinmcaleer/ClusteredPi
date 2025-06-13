# Run this script every 30 minutes to rebalance the Docker Swarm cluster.

```bash
*/30 * * * * /home/kev/ClusteredPi/stacks/balance.sh >> /var/log/balance.log 2>&1
```
