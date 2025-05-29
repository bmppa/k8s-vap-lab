Absolutely! Here's a **Test Plan** to validate the functionality of **Validation Admission Policy (VAP)** in a Kubernetes environment. This assumes you're testing in a non-prod or dev cluster where you can safely deploy new policies.

---

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

---

