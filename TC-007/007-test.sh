#!/bin/bash

set -e

echo "📥 Applying Validation Admission Policy and Binding for TC-007..."
kubectl apply -f 007-policy.yaml
kubectl apply -f 007-binding.yaml

echo -e "\n❌ Testing NON-COMPLIANT pod (missing securityContext)..."
if kubectl apply -f 007-pod-invalid.yaml; then
  echo "❌ ERROR: Pod was accepted but should have been rejected!"
  kubectl get pod
else
  echo "✅ Success: Non-compliant pod was rejected as expected."
  kubectl get pod
fi

echo -e "\n✅ Testing COMPLIANT pod (with runAsNonRoot: true)..."
if kubectl apply -f 007-pod-valid.yaml; then
  echo "✅ Success: Compliant pod was accepted."
  kubectl get pod
else
  echo "❌ ERROR: Compliant pod was rejected!"
  kubectl get pod
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 007-pod-valid.yaml --ignore-not-found
kubectl delete -f 007-pod-invalid.yaml --ignore-not-found
kubectl delete -f 007-binding.yaml
kubectl delete -f 007-policy.yaml

echo -e "\n✅ Test Case TC-007 complete."

