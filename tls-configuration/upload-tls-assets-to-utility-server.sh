#!/bin/bash
#
# Upload locally created TLS assets to the utility server.
IP=$1
ADDR=core@$1
UTILITY_DIR=/etc/kubernetes/ssl
echo $IP

ssh $ADDR "mkdir -p /etc/kubernetes/ssl/"
# scp /etc/kubernetes/ssl/ca.pem $ADDR:/
