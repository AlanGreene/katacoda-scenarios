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
# kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.7.0/tekton-dashboard-release.yaml
cat << EOF | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: extensions.dashboard.tekton.dev
spec:
  group: dashboard.tekton.dev
  names:
    categories:
    - tekton
    - tekton-dashboard
    kind: Extension
    plural: extensions
  scope: Namespaced
  subresources:
    status: {}
  version: v1alpha1
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard
  namespace: tekton-pipelines
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-backend
rules:
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - get
  - list
- apiGroups:
  - security.openshift.io
  resources:
  - securitycontextconstraints
  verbs:
  - use
- apiGroups:
  - route.openshift.io
  resources:
  - routes
  verbs:
  - get
  - list
- apiGroups:
  - extensions
  - apps
  resources:
  - ingresses
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - dashboard.tekton.dev
  resources:
  - extensions
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - tekton.dev
  resources:
  - clustertasks
  - clustertasks/status
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - triggers.tekton.dev
  resources:
  - clustertriggerbindings
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - dashboard.tekton.dev
  resources:
  - extensions
  verbs:
  - create
  - update
  - delete
  - patch
- apiGroups:
  - tekton.dev
  resources:
  - clustertasks
  - clustertasks/status
  verbs:
  - create
  - update
  - delete
  - patch
- apiGroups:
  - triggers.tekton.dev
  resources:
  - clustertriggerbindings
  verbs:
  - create
  - update
  - delete
  - patch
  - add
---
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.dashboard.tekton.dev/aggregate-to-dashboard: "true"
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-extensions
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-pipelines
rules:
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - list
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-tenant
rules:
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  - pods/log
  - namespaces
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - tekton.dev
  resources:
  - tasks
  - taskruns
  - pipelines
  - pipelineruns
  - pipelineresources
  - conditions
  - tasks/status
  - taskruns/status
  - pipelines/status
  - pipelineruns/status
  - taskruns/finalizers
  - pipelineruns/finalizers
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - triggers.tekton.dev
  resources:
  - eventlisteners
  - triggerbindings
  - triggertemplates
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  verbs:
  - update
  - patch
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - delete
- apiGroups:
  - tekton.dev
  resources:
  - tasks
  - taskruns
  - pipelines
  - pipelineruns
  - pipelineresources
  - conditions
  - taskruns/finalizers
  - pipelineruns/finalizers
  - tasks/status
  - taskruns/status
  - pipelines/status
  - pipelineruns/status
  verbs:
  - create
  - update
  - delete
  - patch
- apiGroups:
  - triggers.tekton.dev
  resources:
  - eventlisteners
  - triggerbindings
  - triggertemplates
  verbs:
  - create
  - update
  - delete
  - patch
  - add
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-triggers
rules:
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - list
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-backend
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tekton-dashboard-backend
subjects:
- kind: ServiceAccount
  name: tekton-dashboard
  namespace: tekton-pipelines
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-extensions
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tekton-dashboard-extensions
subjects:
- kind: ServiceAccount
  name: tekton-dashboard
  namespace: tekton-pipelines
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-pipelines
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tekton-dashboard-pipelines
subjects:
- kind: ServiceAccount
  name: tekton-dashboard
  namespace: tekton-pipelines
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-tenant
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tekton-dashboard-tenant
subjects:
- kind: ServiceAccount
  name: tekton-dashboard
  namespace: tekton-pipelines
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/part-of: tekton-dashboard
  name: tekton-dashboard-triggers
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: tekton-dashboard-triggers
subjects:
- kind: ServiceAccount
  name: tekton-dashboard
  namespace: tekton-pipelines
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: tekton-dashboard
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/name: dashboard
    app.kubernetes.io/part-of: tekton-dashboard
    app.kubernetes.io/version: v0.7.0
    dashboard.tekton.dev/release: v0.7.0
    version: v0.7.0
  name: tekton-dashboard
  namespace: tekton-pipelines
spec:
  ports:
  - name: http
    port: 9097
    protocol: TCP
    targetPort: 9097
  selector:
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/name: dashboard
    app.kubernetes.io/part-of: tekton-dashboard
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: tekton-dashboard
    app.kubernetes.io/component: dashboard
    app.kubernetes.io/instance: default
    app.kubernetes.io/name: dashboard
    app.kubernetes.io/part-of: tekton-dashboard
    app.kubernetes.io/version: v0.7.0
    dashboard.tekton.dev/release: v0.7.0
    version: v0.7.0
  name: tekton-dashboard
  namespace: tekton-pipelines
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/component: dashboard
      app.kubernetes.io/instance: default
      app.kubernetes.io/name: dashboard
      app.kubernetes.io/part-of: tekton-dashboard
  template:
    metadata:
      labels:
        app: tekton-dashboard
        app.kubernetes.io/component: dashboard
        app.kubernetes.io/instance: default
        app.kubernetes.io/name: dashboard
        app.kubernetes.io/part-of: tekton-dashboard
        app.kubernetes.io/version: v0.7.0
      name: tekton-dashboard
    spec:
      containers:
      - args:
        - --port=9097
        - --web-dir=/var/run/ko
        - --csrf-secure-cookie=false
        env:
        - name: INSTALLED_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        image: index.docker.io/alangreene/dashboard-9623576a202fe86c8b7d1bc489905f86@sha256:bcb53087bd17bb66f38fdc8a0e48ce9a4ae9d98c3a40890f263ba3b7073d31ff
        livenessProbe:
          httpGet:
            path: /health
            port: 9097
        name: tekton-dashboard
        ports:
        - containerPort: 9097
        readinessProbe:
          httpGet:
            path: /readiness
            port: 9097
      securityContext:
        runAsNonRoot: true
      serviceAccountName: tekton-dashboard
      volumes: []

---
EOF
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