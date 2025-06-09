## 🧪 **Validation Admission Policy - Test Plan**

### 🎯 **Objective**

To validate that Kubernetes Validation Admission Policies (VAP) enforce defined schema-based rules on resource objects and reject those that violate the rules.

---

### 📦 **Test Environment**

* Kubernetes Cluster v1.30+ (VAP GA in 1.30)
* kubectl & access to deploy resources
* CEL expressions for rules
* Admission policies & bindings deployed in `yaml`

---

### 🧪 **Test Scenarios**

| Test Case ID | Description                                                                                   | Resource Type          | Expected Result                                       |
| ------------ | --------------------------------------------------------------------------------------------- | ---------------------- | ----------------------------------------------------- |
| TC-001       | Validate label presence rule                                                                  | Pod                    | Pod without label is rejected                         |
| TC-002       | Enforce image registry prefix (e.g., only allow `myregistry.io`)                              | Pod                    | Pod using image from docker.io is rejected            |
| TC-003       | Ensure container resources (cpu/memory) are set                                               | Pod                    | Pod missing `resources.requests` is rejected          |
| TC-004       | Require naming pattern (e.g., name must start with `app-`)                                    | Deployment             | Deployment named `backend` is rejected                |
| TC-005       | Allow compliant resource                                                                      | Pod                    | Pod meeting all policies is accepted                  |
| TC-006       | Validate annotation presence for ingress (e.g., `nginx.ingress.kubernetes.io/rewrite-target`) | Ingress                | Ingress missing annotation is rejected                |
| TC-007       | Test CEL logic error (invalid expression)                                                     | Admission Policy       | Policy fails to apply, error shown                    |
| TC-008       | Test policy binding in a different namespace                                                  | Namespace-specific Pod | Policy binding applies and rejects non-compliant Pods |

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
