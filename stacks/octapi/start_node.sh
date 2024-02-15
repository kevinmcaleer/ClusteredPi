#!/bin/sh -e
sleep 1
# _IP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
_IP=$(ip addr show eth0 | grep 'inet' | awk '{print $2}' | cut -d/ -f1 | head -n 1)

# _IP=$(hostname -I | awk '{print $1}')
dispynode.py -i $_IP  --daemon --clean
# dispynode.py -i 192.168.2.2 --daemon --clean