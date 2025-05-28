#!/bin/bash

set -e

echo "Applying Validation Admission Policy..."
kubectl apply -f 001-policy.yaml
kubectl apply -f 001-binding.yaml

echo "Testing non-compliant pod (should be rejected)..."
kubectl apply -f 001-pod.yaml || echo "✅ Policy correctly rejected the pod."

echo "Testing compliant pod (should be accepted)..."
kubectl apply -f 001-pod-valid.yaml && echo "✅ Policy correctly accepted the pod."

echo "Done."

