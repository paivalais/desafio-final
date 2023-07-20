#!/bin/bash

echo "============LOGIN INGO - GRAFANA============"
echo "User: admin"
echo "Password: $(kubectl get secret my-grafana-admin --namespace deploy-grafana -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d)"

echo "============LOGIN INGO - WORDPRESS============"
echo Username: user
echo Password: $(kubectl get secret --namespace deploy-ingress my-wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)

echo "============IP DO SERVIÇO DO PROMETHEUS============"
namespace="deploy-ingress"
service="my-prometheus-kube-prometh-prometheus"

ip=$(kubectl get svc --namespace $namespace $service -o jsonpath="{.spec.clusterIP}")

echo "IP do serviço $service na namespace $namespace: $ip"
