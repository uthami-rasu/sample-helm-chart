# Helm Application Chart 🚀

This is a production-grade Helm chart for the Helm application, consisting of a Spring Boot backend and a Flutter frontend.

## 📁 Structure

- **Backend**: Spring Boot application.
- **Frontend**: Flutter web application.

## 🚀 Quick Start

### 1. Prerequisites

- Helm 3.x
- Kubernetes cluster with Traefik Ingress Controller
- `kubectl` configured

### 2. Deploy

The easiest way to deploy is using the provided `deploy.sh` script, which handles namespace creation and the Helm upgrade.

```bash
./deploy.sh my-namespace
```

Alternatively, you can use standard Helm commands:

#### **Initial Install or Upgrade**

The following command will install the chart if it doesn't exist, or upgrade it if it does:

```bash
helm upgrade --install my-release . -n my-namespace --create-namespace
```

#### **Manual Override**

To override specific values (like the database URL or JWT secret) without editing `values.yaml`:

```bash
helm upgrade --install my-release . \
  --set backend.database.url="jdbc:postgresql://your-db:5432/db" \
  --set backend.jwt.secret="new-secret" \
  -n my-namespace
```

## 📊 Configuration (`values.yaml`)

Configuration is managed in the single `values.yaml` file. You can override any value during installation using the `--set` flag or by creating a custom values file.

To deploy in a specific namespace:

```bash
helm upgrade --install my-release . -n my-namespace --create-namespace
```

To override values:

```bash
helm upgrade --install my-release . --set backend.database.password=MY_PASS -n my-namespace
```

## 🔐 Secrets Management

### 1. Docker Registry Secret

Required for pulling images from private registries.

```bash
kubectl create secret docker-registry regcred-prod \
  --docker-server=docker.io \
  --docker-username=YOUR_USER \
  --docker-password=YOUR_PASS \
  -n task-app-prod
```

### 2. TLS Secret (HTTPS)

Required for secure communication.

```bash
kubectl create secret tls helm-tls-prod \
  --cert=/path/to/cert.crt \
  --key=/path/to/key.key \
  -n task-app-prod
```

### 3. Application Secrets (DB, JWT)

Managed through `values.yaml` and deployed via `secrets.yaml`.

## 📋 Common Commands Cheat Sheet

| Task              | Command                                                          |
| ----------------- | ---------------------------------------------------------------- |
| **Check Pods**    | `kubectl get pods -n task-app-prod`                              |
| **Check Ingress** | `kubectl get ingress -n task-app-prod`                           |
| **View Logs**     | `kubectl logs deployment/task-app-prod-backend -n task-app-prod` |
| **Rollback**      | `helm rollback task-app-prod -n task-app-prod`                   |
| **Uninstall**     | `helm uninstall task-app-prod -n task-app-prod`                  |

## 🛠️ Troubleshooting

- **ImagePullBackOff**: Check if `regcred` secret exists in the namespace.
- **Pending Pods**: Run `kubectl describe pod <pod-name>` to check for resource issues or unschedulable nodes.
- **DB Connection**: Verify `database.url` and credentials in the consolidated `values.yaml`.
- **404 Not Found**: Ensure Ingress host matches your domain and the Ingress controller is running.
