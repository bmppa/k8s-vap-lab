#!/bin/bash

set -e

echo "📥 Applying Validation Admission Policy and Binding for TC-003..."
kubectl apply -f 003-policy.yaml
kubectl apply -f 003-binding.yaml

sleep 5

echo -e "\n❌ Testing NON-COMPLIANT pod (no resource requests)..."
if kubectl apply -f 003-pod-invalid.yaml; then
  echo "❌ ERROR: Pod was accepted but should have been rejected!"
  kubectl get pod
else
  echo "✅ Success: Non-compliant pod was rejected as expected."
  kubectl get pod
fi

echo -e "\n✅ Testing COMPLIANT pod (has resource requests)..."
if kubectl apply -f 003-pod-valid.yaml; then
  echo "✅ Success: Compliant pod was accepted."
  kubectl get pod
else
  echo "❌ ERROR: Compliant pod was rejected!"
  kubectl get pod
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 003-pod-valid.yaml --ignore-not-found
kubectl delete -f 003-pod-invalid.yaml --ignore-not-found
kubectl delete -f 003-binding.yaml
kubectl delete -f 003-policy.yaml

echo -e "\n✅ Test Case TC-003 complete."

