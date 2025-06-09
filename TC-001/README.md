## ✅ **Step-by-Step Instructions**

These steps are similar to all test cases. Make sure you check the file names before running the commands.

### 1. 📁 Clone or navigate to the test directory

```
git clone https://github.com/bmppa/k8s-vap-lab.git
cd k8s-vap-lab/TC-001
```

> Replace the 1 in TC-001 with the test case number you want to try.

---

### 2. 📥 Apply the Validation Admission Policy and Binding

```
kubectl apply -f 001-policy.yaml
kubectl apply -f 001-binding.yaml
```

---

### 3. 🚫 Attempt to Create a Pod/Deployment/Ingress (Should Be Rejected)

```
kubectl apply -f 001-pod-invalid.yaml
```

Expected output:

```
The pods "test-pod-invalid" is invalid: : ValidatingAdmissionPolicy 'require-app-label' with binding 'require-app-label-binding' denied request: 
Missing required label 'app'
```

✅ This confirms the policy is working.

---

### 4. ✅ Try a Compliant Pod with a Label (Should Be Accepted)

```
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
