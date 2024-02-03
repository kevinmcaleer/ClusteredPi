# Build your Docker image
docker build -t 192.168.2.1:5000/kevsrobots:latest . --no-cache

# Push your Docker image
# docker push search:latest
docker push 192.168.2.1:5000/kevsrobots:latest