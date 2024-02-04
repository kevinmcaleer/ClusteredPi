# Build your Docker image
docker build -t 192.168.2.1:5000/kevsrobots:latest . --no-cache

# Push your Docker image
# docker push search:latest
docker push 192.168.2.1:5000/kevsrobots:latest
docker stack deploy -c docker-compose.yml kevsrobots
docker service update --image 192.168.2.1:5000/kevsrobots:latest kevsrobots_kevsrobots
