#!/bin/sh -e
sleep 1
_IP=$(hostname -i | awk '{print $1}')
dispynode.py -i $_IP --daemon