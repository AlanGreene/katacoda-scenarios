#!/bin/bash

# Start Kubernetes
echo "Starting cluster"
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
#   && chmod +x minikube
# ./minikube start --kubernetes-version v1.18.3
# ./minikube addons enable ingress
# curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
#   && chmod +x minikube
minikube start
minikube addons enable ingress
echo "done" >> /opt/.clusterstarted

echo "Installing Tekton Pipelines"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.13.2/release.yaml
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

external_ip=""
while [ -z $external_ip ]; do
  echo "Waiting for external IP..."
  external_ip=$(kubectl get -n tekton-pipelines ingress tekton-dashboard --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$external_ip" ] && sleep 10
done
echo "done" >> /opt/.externalipready

echo "done" >> /opt/.backgroundfinished
