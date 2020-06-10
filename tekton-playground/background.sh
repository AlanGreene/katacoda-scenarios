#!/bin/bash

# Start Kubernetes
echo "Starting cluster"
minikube start
minikube addons enable ingress
echo "done" >> /opt/.clusterstarted

echo "Installing Tekton Pipelines"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.13.1/release.yaml
echo "done" >> /opt/.pipelinesinstalled

echo "Installing Tekton Dashboard"
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.7.0/tekton-dashboard-release.yaml
echo "done" >> /opt/.dashboardinstalled

echo "Waiting for Tekton pods to be ready"
kubectl wait pod -n tekton-pipelines --all --for=condition=Ready --timeout=90s
echo "done" >> /opt/.podsready

echo "Configure ingress"
kubectl wait pod -n kube-system --all --for=condition=Ready --timeout=90s

cat << EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: tekton-dashboard
  namespace: tekton-pipelines
spec:
  backend:
    serviceName: tekton-dashboard
    servicePort: 9097
EOF

echo "done" >> /opt/.ingressconfigured

# Verify the Ingress was created
kubectl get ingress -n tekton-pipelines

echo "done" >> /opt/.backgroundfinished
