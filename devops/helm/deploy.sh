#!/bin/bash
# Simplified Helm deployment script

set -e

NAMESPACE=${1:-task-app}
RELEASE_NAME="task-app"

echo "🚀 Deploying to namespace: $NAMESPACE..."

# Step 1: Create namespace
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Step 2: Deploy with Helm
echo "📊 Deploying Helm chart..."
helm upgrade --install "$RELEASE_NAME" . \
  -f values.yaml \
  -n "$NAMESPACE"

echo "✅ Deployment complete!"
echo "Release: $RELEASE_NAME"
echo "Namespace: $NAMESPACE"
