## 🧪 **Test Case TC-001 – Disallow `latest` Image Tags**

### 🎯 **Objective**

Reject any Pod where a container image tag is set to `latest`.

---

## ✅ **Step-by-Step Instructions to Run TC-001**

### 1. 📁 Clone or navigate to the test directory

```bash
git clone https://github.com/bmppa/k8s-vap-lab.git
cd k8s-vap-lab/TC-001
```

> Make sure you're in the folder that contains the following files:

```
tc-001/
├── 001-policy.yaml
├── 001-binding.yaml
├── 001-pod-invalid.yaml
├── 001-pod-valid.yaml
└── 001-test.sh
```

---

### 2. 📥 Apply the Validation Admission Policy and Binding

```
kubectl apply -f 001-policy.yaml
kubectl apply -f 001-binding.yaml
```

---

### 3. 🚫 Attempt to Create a Pod Using `:latest` (Should Be Rejected)

```
kubectl apply -f 001-pod-invalid.yaml
```

Expected output:

```
Error from server: admission webhook "validation.policy.k8s.io" denied the request:
Image tag 'latest' is not allowed
```

✅ This confirms the policy is working.

---

### 4. ✅ Try a Compliant Pod with a Fixed Tag (Should Be Accepted)

```bash
kubectl apply -f 001-pod-valid.yaml
```

Expected output:

```
pod/test-pod-valid created
```

---

### 5. ⚙️ Run the Automated Test Script

Alternatively, run the entire test with one script:

```
chmod +x 001-test.sh
./001-test.sh
```

This script will:

* Apply the policy and binding
* Try both violating and compliant pods
* Report pass/fail
* Clean up resources

---

### 6. 🧹 Clean Up After Test

If not using the script, clean up manually:

```
kubectl delete -f 001-pod-invalid.yaml --ignore-not-found
kubectl delete -f 001-pod-valid.yaml --ignore-not-found
kubectl delete -f 001-binding.yaml
kubectl delete -f 001-policy.yaml
```

---

## 🔚 You're Done!

✅ You've just tested **native image tag validation** in Kubernetes using Validation Admission Policies — no external webhook required.
