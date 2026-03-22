# Helm Project - Kubernetes Deployment

This directory contains the necessary Kubernetes manifests to deploy the Helm project.

## Directory Structure

```text
devops/
└── k8s/
    ├── configmap.yaml             # Shared environment variables
    ├── secrets.yaml               # Sensitive data (DB password, JWT secret)
    ├── backend-deployment.yaml    # Backend Deployment & Service
    └── frontend-deployment.yaml   # Frontend Deployment & Service
```

## Prerequisites

1. A running Kubernetes cluster (e.g., Minikube, Kind, or a cloud provider).
2. `kubectl` configured to point to your cluster.
3. Docker images pushed to Docker Hub (Done: `therazz28/helm-backend` and `therazz28/helm-frontend`).

## Deployment Steps

Apply the manifests in the following order:

### 1. Namespace

```bash
kubectl apply -f devops/k8s/namespace.yaml
```

### 2. Configuration

```bash
kubectl apply -f devops/k8s/configmap.yaml
kubectl apply -f devops/k8s/secrets.yaml
```

```bash
kubectl apply -f devops/k8s/backend-deployment.yaml
```

### 3. Frontend

```bash
kubectl apply -f devops/k8s/frontend-deployment.yaml
```

### 4. Ingress (Optional - for Domain Routing)

```bash
kubectl apply -f devops/k8s/ingress.yaml
```

## Post-Deployment

Check the status of your pods:

```bash
kubectl get pods -n task-app
```

### Accessing via Ingress (helm.local)

1. Get the Ingress IP:
   ```bash
   kubectl get ingress -n task-app helm-ingress
   ```
2. Map `helm.local` in your `/etc/hosts`:
   ```text
   <INGRESS_IP_FROM_STEP_1> helm.local
   ```
3. Open **http://helm.local** in your browser.

Access the frontend:

- If using a cloud provider (LoadBalancer): `kubectl get svc helm-frontend`
- If using Minikube: `minikube service helm-frontend`
- If using Port-Forward (Manual): `kubectl port-forward svc/helm-frontend 8080:80`
