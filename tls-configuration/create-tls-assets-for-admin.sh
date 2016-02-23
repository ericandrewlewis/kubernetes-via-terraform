#!/bin/bash
#

mkdir -p /etc/kubernetes/ssl/admin/;
openssl genrsa -out /etc/kubernetes/ssl/admin/admin-key.pem 2048;
openssl req -new -key /etc/kubernetes/ssl/admin/admin-key.pem -out /etc/kubernetes/ssl/admin/admin.csr -subj "/CN=kube-admin";
openssl x509 -req \
	-in /etc/kubernetes/ssl/admin/admin.csr \
	-CA /etc/kubernetes/ssl/ca/ca.pem \
	-CAkey /etc/kubernetes/ssl/ca/ca-key.pem \
	-CAcreateserial \
	-out /etc/kubernetes/ssl/admin/admin.pem \
	-days 365;
