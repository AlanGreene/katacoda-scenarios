# Wait for Katacoda to initialize
sleep 1

# Start Kubernetes
minikube start && minikube addons enable ingress

# Wait
launch.sh
