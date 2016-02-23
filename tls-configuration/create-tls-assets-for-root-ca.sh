#!/bin/bash
#
# Creates the TLS assets required for the cluster root CA.

mkdir -p /etc/kubernetes/ssl/ca;
openssl genrsa -out /etc/kubernetes/ssl/ca/ca-key.pem 2048;
openssl req -x509 \
  -new \
  -nodes \
	-key /etc/kubernetes/ssl/ca/ca-key.pem \
	-days 10000 \
	-out /etc/kubernetes/ssl/ca/ca.pem \
	-subj "/CN=kube-ca"
