#!/bin/bash

set -e

echo "📥 Applying Validation Admission Policy and Binding for TC-004..."
kubectl apply -f 004-policy.yaml
kubectl apply -f 004-binding.yaml

sleep 5

echo -e "\n❌ Testing NON-COMPLIANT deployment (name: backend-service)..."
if kubectl apply -f 004-deploy-invalid.yaml; then
  echo "❌ ERROR: Deployment was accepted but should have been rejected!"
  kubectl get deploy
else
  echo "✅ Success: Non-compliant deployment was rejected as expected."
  kubectl get deploy
fi

echo -e "\n✅ Testing COMPLIANT deployment (name: app-backend)..."
if kubectl apply -f 004-deploy-valid.yaml; then
  echo "✅ Success: Compliant deployment was accepted."
  kubectl get deploy
else
  echo "❌ ERROR: Compliant deployment was rejected!"
  kubectl get deploy
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 004-deploy-valid.yaml --ignore-not-found
kubectl delete -f 004-deploy-invalid.yaml --ignore-not-found
kubectl delete -f 004-binding.yaml
kubectl delete -f 004-policy.yaml

echo -e "\n✅ Test Case TC-004 complete."

