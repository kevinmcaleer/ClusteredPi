#!/bin/sh -e
sleep 30
_IP=$(hostname -I | awk '{print $1}')
dispynode.py -i $_IP --daemon