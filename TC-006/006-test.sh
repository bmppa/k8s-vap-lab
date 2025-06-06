#!/bin/bash

set -e

echo "📥 Applying Validation Admission Policy and Binding for TC-006 (Ingress annotation)..."
kubectl apply -f 006-policy.yaml
kubectl apply -f 006-binding.yaml

sleep 5

echo -e "\n❌ Testing NON-COMPLIANT Ingress (missing annotation)..."
if kubectl apply -f 006-ingress-invalid.yaml; then
  echo "❌ ERROR: Ingress was accepted but should have been rejected!"
  kubectl get ingress
else
  echo "✅ Success: Non-compliant Ingress was rejected as expected."
  kubectl get ingress
fi

echo -e "\n✅ Testing COMPLIANT Ingress (with rewrite-target)..."
if kubectl apply -f 006-ingress-valid.yaml; then
  echo "✅ Success: Compliant Ingress was accepted."
  kubectl get ingress
else
  echo "❌ ERROR: Compliant Ingress was rejected!"
  kubectl get ingress
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 006-ingress-valid.yaml --ignore-not-found
kubectl delete -f 006-ingress-invalid.yaml --ignore-not-found
kubectl delete -f 006-binding.yaml
kubectl delete -f 006-policy.yaml

echo -e "\n✅ Test Case TC-006 complete."

