# Kubernetes system configuration

## [Configuration instructions](./Kubernetes.md)

## Directory structure

- [External-dns](./external-dns)
- [Gcloud Builder](./gcloud)
- [Helm Builder](./helm)
- [Namespaces](./namespaces/)
- [Pod Security Policies](./psp/)
- [Network policies](./network-policy/)
- [Role-based access control (RBAC)](./rbac)

## Login

List all GKE clusters:

```bash
gcloud container clusters list
```

Provide cluster name and region to login in a cluster:

```bash
gcloud container clusters get-credentials ${cluster_name} --region ${region}

# development
gcloud container clusters get-credentials development --region northamerica-northeast1

# production
gcloud container clusters get-credentials production --region us-east1
```

## Tools

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs. For a complete list of kubectl operations, see [Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

- [k9s](https://github.com/derailed/k9s) provides a curses based terminal UI to interact with your Kubernetes clusters. K9s continually watches Kubernetes for changes and offers subsequent commands to interact with observed Kubernetes resources.

- [kubectx](https://github.com/ahmetb/kubectx#kubectx1) is a utility to manage and switch between kubectl contexts.

- [kubens](https://github.com/ahmetb/kubectx#kubens1) is a utility to switch between Kubernetes namespaces.

- [stern](https://github.com/wercker/stern) allows you to tail multiple pods on Kubernetes and multiple containers within the pod. Each result is color coded for quicker debugging.

## Apply configuration  

You can apply each kube-system component independetly using `kubectl`:

```bash
kubectl apply -f directoryName
```

or you can use Cloud build - [cloudbuild.yaml](./cloudbuild.yaml) contains a list of `kube-system` components to be applied from Cloud Build pipeline.

Run `gcloud build` and provide cluster name and location:

```bash
gcloud builds submit \
    --substitutions=_CLUSTER="development" \
    --substitutions=_LOCATION="northamerica-northeast1"
```

## GKE Clusters and NodePools

Cluster and NodePool resources are defined in [gke.tf](../development/gke.tf) file.

### Upgrades

Cluster is configured to use [Stable Release channel](https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels) for [Cluster upgrades](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-upgrades).

When you enroll a new cluster in a release channel, Google automatically manages the version and upgrade cadence for the cluster and its node pools, selecting only versions available in that channel.

A version must meet increasing stability requirements to be eligible for a more stable channel, and more stable channels receive fewer, less frequent updates.

Release channel is set in [gke_cluster](../../modules/gke_cluster/main.tf) Terraform module:

```ruby
  release_channel {
    channel = "STABLE"
  }
```

### Creating new node pools

Basic way to update node pool in your clusters is to create a new node pool and migrate your pods to that pool.

Migrating to a new node pool is more graceful than simply updating existing node pool configuration, because the migration process taints the old node pool as NoSchedule and drains the nodes after a new pool is ready to accept the existing pod workload.

Copy existing node pool resource and use it as a template for new node pool. Then you can migrate all pods to the new pool and delete old one.
