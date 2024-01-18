docker service create \
  --name dash \
  --restart-condition on-failure \
  --mount type=bind,source=/,target=/mnt/host,readonly \
  --publish published=80,target=3001 \
  --privileged \
  mauricenino/dashdot:latest