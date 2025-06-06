#!/bin/bash

set -e

echo "📥 Applying Validation Admission Policy and Binding..."
kubectl apply -f 002-policy.yaml
kubectl apply -f 002-binding.yaml

sleep 5

echo -e "\n❌ Testing NON-COMPLIANT pod (docker.io/nginx)..."
if kubectl apply -f 002-pod-invalid.yaml; then
  echo "❌ ERROR: Pod was accepted but should have been rejected!"
  kubectl get pod
else
  echo "✅ Success: Non-compliant pod was rejected as expected."
  kubectl get pod
fi

echo -e "\n✅ Testing COMPLIANT pod (docker.io/bmppa)..."
if kubectl apply -f 002-pod-valid.yaml; then
  echo "✅ Success: Compliant pod was accepted."
  sleep 5
  kubectl get pod
else
  echo "❌ ERROR: Compliant pod was rejected!"
  kubectl get pod
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 002-pod-valid.yaml --ignore-not-found
kubectl delete -f 002-pod-invalid.yaml --ignore-not-found
kubectl delete -f 002-binding.yaml
kubectl delete -f 002-policy.yaml

echo -e "\n✅ Test Case TC-002 complete."

