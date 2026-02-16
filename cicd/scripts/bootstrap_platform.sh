#!/usr/bin/env bash
set -euo pipefail

wait_crd() {
  local crd_name="$1"
  kubectl wait --for=condition=Established --timeout=180s "crd/${crd_name}" >/dev/null
}

helm repo add --force-update ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null
helm repo add --force-update argo https://argoproj.github.io/argo-helm >/dev/null
helm repo add --force-update prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo add --force-update elastic https://helm.elastic.co >/dev/null
helm repo add --force-update fluent https://fluent.github.io/helm-charts >/dev/null
helm repo add --force-update jaegertracing https://jaegertracing.github.io/helm-charts >/dev/null
helm repo add --force-update external-secrets https://charts.external-secrets.io >/dev/null
helm repo add --force-update hashicorp https://helm.releases.hashicorp.com >/dev/null
helm repo update >/dev/null

kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace security --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  -n ingress-nginx -f helm-values/ingress-nginx-values.yaml

helm upgrade --install argo-rollouts argo/argo-rollouts \
  -n mis-prod --create-namespace -f helm-values/argo-rollouts-values.yaml

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -n observability -f helm-values/kube-prometheus-stack-values.yaml

helm upgrade --install elasticsearch elastic/elasticsearch \
  -n observability -f helm-values/elasticsearch-values.yaml

helm upgrade --install logstash elastic/logstash \
  -n observability -f helm-values/logstash-values.yaml

helm upgrade --install kibana elastic/kibana \
  -n observability -f helm-values/kibana-values.yaml

helm upgrade --install fluent-bit fluent/fluent-bit \
  -n observability -f helm-values/fluent-bit-values.yaml

helm upgrade --install jaeger jaegertracing/jaeger \
  -n observability -f helm-values/jaeger-values.yaml

helm upgrade --install external-secrets external-secrets/external-secrets \
  -n security -f helm-values/external-secrets-values.yaml

helm upgrade --install vault hashicorp/vault \
  -n security -f helm-values/vault-values.yaml

wait_crd "rollouts.argoproj.io"
wait_crd "externalsecrets.external-secrets.io"
wait_crd "servicemonitors.monitoring.coreos.com"
wait_crd "prometheusrules.monitoring.coreos.com"

echo "Platform bootstrap complete"
