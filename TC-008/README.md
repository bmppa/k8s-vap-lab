## 🧪 **TC-008 – Namespace-Specific Policy Binding**

### ✅ **Goal**

Ensure a **namespace-scoped** ValidationAdmissionPolicyBinding applies only to resources **within its target namespace**, and is **not enforced** in other namespaces.

---

## 🧩 **Policy Concept**

We’ll:

* Create a policy that requires the `team` label on Pods.
* Bind it **only to `dev-ns` namespace**.
* Deploy a violating pod in both `dev-ns` (should be **rejected**) and `prod-ns` (should be **accepted**).

---

## 🛠️ Setup

### 🔐 **1. Validation Admission Policy – Require `team` Label**

```yaml
# require-team-label-policy.yaml
apiVersion: admissionregistration.k8s.io/v1alpha1
kind: ValidationAdmissionPolicy
metadata:
  name: require-team-label
spec:
  matchConstraints:
    resourceRules:
      - apiGroups: [""]
        apiVersions: ["v1"]
        operations: ["CREATE"]
        resources: ["pods"]
  validations:
    - expression: "object.metadata.labels.exists('team')"
      message: "Pods must have a 'team' label"
```

---

### 🔗 **2. Namespace-Scoped Policy Binding (Only applies to `dev-ns`)**

```yaml
# require-team-label-binding-dev.yaml
apiVersion: admissionregistration.k8s.io/v1alpha1
kind: ValidationAdmissionPolicyBinding
metadata:
  name: require-team-label-binding-dev
spec:
  policyName: require-team-label
  validationActions: ["Deny"]
  matchResources:
    namespaceSelector:
      matchLabels:
        env: dev
```

---

### 🌐 **3. Namespaces with Labels**

```yaml
# namespaces.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev-ns
  labels:
    env: dev
---
apiVersion: v1
kind: Namespace
metadata:
  name: prod-ns
  labels:
    env: prod
```

---

### ❌ **4. Violating Pod in Both Namespaces (Missing `team` Label)**

```yaml
# pod-missing-team-label.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod-no-team
spec:
  containers:
    - name: nginx
      image: nginx
```

---

## ⚙️ **5. Bash Script – `test-tc008.sh`**

```bash
#!/bin/bash

set -e

echo "📥 Creating Namespaces with labels..."
kubectl apply -f namespaces.yaml

echo "📥 Applying Validation Admission Policy and Namespace-scoped Binding..."
kubectl apply -f require-team-label-policy.yaml
kubectl apply -f require-team-label-binding-dev.yaml

echo -e "\n🔬 Testing in 'dev-ns' (should be REJECTED)..."
if kubectl apply -f pod-missing-team-label.yaml -n dev-ns; then
  echo "❌ ERROR: Pod was accepted in 'dev-ns' but should have been rejected!"
else
  echo "✅ Success: Pod was correctly rejected in 'dev-ns'."
fi

echo -e "\n🔬 Testing in 'prod-ns' (should be ACCEPTED)..."
if kubectl apply -f pod-missing-team-label.yaml -n prod-ns; then
  echo "✅ Success: Pod was correctly accepted in 'prod-ns'."
else
  echo "❌ ERROR: Pod was rejected in 'prod-ns' but should have been accepted!"
fi

echo -e "\n🧹 Cleaning up..."
kubectl delete pod test-pod-no-team -n prod-ns --ignore-not-found
kubectl delete pod test-pod-no-team -n dev-ns --ignore-not-found
kubectl delete -f require-team-label-binding-dev.yaml
kubectl delete -f require-team-label-policy.yaml
kubectl delete ns dev-ns prod-ns --ignore-not-found

echo -e "\n✅ Test Case TC-008 complete."
```

---

## 📁 Suggested Folder Structure

```
tc-008/
├── require-team-label-policy.yaml
├── require-team-label-binding-dev.yaml
├── namespaces.yaml
├── pod-missing-team-label.yaml
└── test-tc008.sh
```

