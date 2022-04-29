#!/bin/bash

echo "Installing Tekton Pipelines"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.13.2/release.yaml
echo "done" >> /opt/.pipelinesinstalled

echo "Installing Tekton Dashboard"
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.7.0/tekton-dashboard-release.yaml
echo "done" >> /opt/.dashboardinstalled

echo "Waiting for Tekton pods to be ready"
kubectl wait pod -n tekton-pipelines --all --for=condition=Ready --timeout=90s
echo "done" >> /opt/.podsready

echo "Configure port forward"
kubectl --namespace tekton-pipelines port-forward --address 0.0.0.0 service/tekton-dashboard 9097:9097 &
echo "done" >> /opt/.portforwardconfigured

echo "done" >> /opt/.backgroundfinished
