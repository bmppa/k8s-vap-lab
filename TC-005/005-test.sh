#!/bin/bash

set -e

echo "📥 Applying Validation Admission Policy and Binding for TC-005..."
kubectl apply -f 005-policy.yaml
kubectl apply -f 005-binding.yaml

sleep 5

echo -e "\n❌ Testing NON-COMPLIANT pod (nginx:latest)..."
if kubectl apply -f 005-pod-invalid.yaml; then
  echo "❌ ERROR: Pod was accepted but should have been rejected!"
  kubectl get pod
else
  echo "✅ Success: Non-compliant pod was rejected as expected."
  kubectl get pod
fi

echo -e "\n✅ Testing COMPLIANT pod (nginx:1.25.2)..."
if kubectl apply -f 005-pod-valid.yaml; then
  echo "✅ Success: Compliant pod was accepted."
  kubectl get pod
else
  echo "❌ ERROR: Compliant pod was rejected!"
  kubectl get pod
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 005-pod-invalid.yaml --ignore-not-found
kubectl delete -f 005-pod-valid.yaml --ignore-not-found
kubectl delete -f 005-binding.yaml
kubectl delete -f 005-policy.yaml

echo -e "\n✅ Test Case TC-005 complete."

