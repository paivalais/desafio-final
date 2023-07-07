#!/bin/bash

echo "============LOGIN INGO - GRAFANA============"
echo "User: admin"
echo "Password: $(kubectl get secret my-grafana-admin --namespace deploy-ingress -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d)"

echo "============LOGIN INGO - WORDPRESS============"
echo Username: user
echo Password: $(kubectl get secret --namespace deploy-ingress my-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)
