#!/bin/bash

set -e

echo "--- Starting local automation script for cloud-app ---"
nano src/main/kotlin/md/utm/cloudapp/rest/MainController.kt

echo "Press Enter to continue..."
read

echo "--- Running local GitHub Actions simulation with 'act' ---"
act -j build -r

echo "--- 'act' simulation completed. Image should be pushed to Docker Hub. ---"

echo "--- Pulling the latest Docker image from Docker Hub ---"
docker pull commin4u/cloud-app:latest

echo "--- Docker image 'commin4u/cloud-app:latest' pulled. ---"

echo "--- Triggering Kubernetes rolling restart for cloud-app-deployment ---"
kubectl rollout restart deployment/cloud-app-deployment -n default
echo "--- Kubernetes rollout restart initiated. ---"

echo "--- Monitoring Kubernetes rollout status (Ctrl+C to stop monitoring) ---"
kubectl rollout status deployment/cloud-app-deployment -n default --watch

echo "--- Rollout status check finished. ---"

echo "--- Preparing to commit and push changes ---"
git add .
git commit -m "feat: Apply latest changes and tested locally"
git push origin main
echo "--- Local automation script finished. ---"
