#!/bin/bash

set -e

echo "📥 Creating Namespaces with labels..."
kubectl apply -f 008-ns.yaml

echo "📥 Applying Validation Admission Policy and Namespace-scoped Binding..."
kubectl apply -f 008-policy.yaml
kubectl apply -f 008-binding.yaml

sleep 5

echo -e "\n🔬 Testing in 'dev-ns' (should be REJECTED)..."
if kubectl apply -f 008-pod.yaml -n dev-ns; then
  kubectl get pod -A
  echo "❌ ERROR: Pod was accepted in 'dev-ns' but should have been rejected!"
else
  echo -e "✅ Success: Pod was correctly rejected in 'dev-ns'.\n"
  kubectl get pod -A
fi

echo -e "\n🔬 Testing in 'prod-ns' (should be ACCEPTED)..."
if kubectl apply -f 008-pod.yaml -n prod-ns; then
  echo -e "✅ Success: Pod was correctly accepted in 'prod-ns'.\n"
  kubectl get pod -A
else
  echo "❌ ERROR: Pod was rejected in 'prod-ns' but should have been accepted!"
  kubectl get pod -A
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete -f 008-binding.yaml
kubectl delete -f 008-policy.yaml
kubectl delete ns dev-ns prod-ns --ignore-not-found

echo -e "\n✅ Test Case TC-008 complete."

