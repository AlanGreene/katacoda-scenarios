# Wait for Katacoda to initialize
sleep 1

# Start Kubernetes
#launch.sh

#apt update

#apt install -y kubeadm=1.15.11-00

# kubeadm reset --force

#kubeadm init --kubernetes-version $(kubeadm version -o short)

# # Install Tekton Pipelines
# kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# # Install Tekton Triggers
# kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml

# # Install Tekton Dashboard
# kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.3.0/dashboard-latest-release.yaml
# kubectl port-forward -n tekton-pipelines svc/tekton-dashboard 9097:9097 &
