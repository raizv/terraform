# Namespaces

[namespaces.yaml](namespaces.yaml) contains list of kubernetes namespaces within a cluster.

## [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces can not be nested inside one another and each Kubernetes resource can only be in one namespace.

- `kube-system` - namespace for kubernetes system services (fluentd, prometheus, metrics and etc)
- `clientoutlook` - default namespace for eunity deployments (edge, edge3d, rendering-3d)

### Switch namespaces

You can use [kubens](https://github.com/ahmetb/kubectx#kubens1) cli tool to change between namespaces:

```bash
kubens kube-system

Context "gke_development-7c02bb4b_northamerica-northeast1_development" modified.
Active namespace is "kube-system".
```

### List namespaces

```bash
kubectl get ns

NAME            STATUS   AGE
clientoutlook   Active   8d
default         Active   8d
kube-public     Active   8d
kube-system     Active   8d
```

### Create new namespace

Add new namespace object to [namespaces.yaml](./namespaces.yaml) to create a namespace:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: namespace-name
```

then run `kubectl apply` command:

```bash
kubectl apply -f namespaces.yaml
```
