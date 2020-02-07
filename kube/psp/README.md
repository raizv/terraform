# [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)

Pod Security Policies enable fine-grained authorization of pod creation and updates.

A Pod Security Policy is a cluster-level resource that controls security sensitive aspects of the pod specification. The PodSecurityPolicy objects define a set of conditions that a pod must run with in order to be accepted into the system, as well as defaults for the related fields.

## Privileged Policy

[psp-privileged.yaml](./psp-privileged.yaml) - this is the least restricted policy you can create, equivalent to not using the pod security policy admission controller. This policy is applied to `kube-system` namespace.

## Restricted Policy

[psp-restricted.yaml](./psp-restricted.yaml) - this is a restrictive policy that requires users to run as an unprivileged user, blocks possible escalations to root, and requires use of several security mechanisms.

You can description of each field in [Policy Reference](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#policy-reference).

## RBAC

When a `PodSecurityPolicy` resource is created, it does nothing. In order to use it, the requesting user or target pod’s service account must be authorized to use the policy, by allowing the use verb on the policy.

- [rbac-privileged.yaml](./rbac-privileged.yaml) allows to use `psp-02-privileged` policy in `kube-system` namespace.
- [rbac-restricted.yaml](./rbac-restricted.yaml) allows to use `psp-01-restricted` policy in all namespaces with default service account.

You can find more details about RBAC auth and policies [here](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#authorizing-policies).

List all pod security policies:

```bash
kubectl get psp
```

Run `kubectl apply` on `psp` directory to apply pod security policies and RBAC configuration:

```bash
kubectl apply -f psp
```

## [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

A security context defines privilege and access control settings for a Pod or Container.

`securityContext` field in a deployment is required to comply with restricted security policy. You can use any numeric value except 0:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.appName }}
  namespace: {{ .Values.namespace }}
spec:
  replicas: {{ .Values.replicas }}
  selector:
    matchLabels:
      app: {{ .Values.appName }}
  template:
    metadata:
      labels:
        app: {{ .Values.appName }}
    spec:
      securityContext:
        runAsUser: 1000
```

## GKE Configuration

Pod Security Policy support is enabled by default in [gke_cluster](../../modules/gke_cluster/main.tf) Terraform module:

```ruby
  pod_security_policy_config {
    enabled = true
  }
```
