# [Network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints. `NetworkPolicy` resources use labels to select pods and define rules which specify what traffic is allowed to the selected pods.

Each namespace has a network policy `allow-from-kube-system-namespace`:

- Allows ingress traffic between pods within namespaces
- Allows ingress traffic from `kube-system` namespaces
- Denies ingress traffic from other namespaces

## How it works

`kube-system` namespace has a label `namespace: kube-system`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: kube-system
  labels:
    namespace: kube-system
```

NetworkPolicy object applies to `namespace: clientoutlook` with `namespaceSelector` to match the label `namespace: kube-system`:

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-from-kube-system-namespace
  namespace: clientoutlook
spec:
  # apply to all pods within namespace
  podSelector: {}
  ingress:
  - from:
    # allow traffic within namespace
    - podSelector: {}
    - namespaceSelector:
        matchLabels:
          # allow traffic from kube-system namespace
          namespace: kube-system
```

You can find more examples of network policies in this [repo](https://github.com/ahmetb/kubernetes-network-policy-recipes).

## GKE configuration

Network policy support is enabled by default in [gke_cluster](../../modules/gke_cluster/main.tf) Terraform module:

  ```ruby
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  ```
