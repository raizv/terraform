# [RBAC](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control)

[Role-based access control](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) is a method of regulating access to computer or network resources based on the roles of individual users within an enterprise.

## Configuration

[template.yaml](template.yaml) contains RBAC configuration.
Cluster Role Binding links G Suite group to kubernetes Cluster Role.

Example: grant `gke-edit@clientoutlook.com` group `edit` role permission.

```yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # Binding name
  name: cluster-edit-binding
subjects:
- kind: Group
  # G Suite group name
  name: gke-edit@clientoutlook.com
roleRef:
  kind: ClusterRole
  # cluster role name
  name: edit
  apiGroup: rbac.authorization.k8s.io
```

`gke-edit` G Suit group should be a member of `gke-security-groups@clientoutlook.com` group.

## Usage

Run `kubectl apply` to create or update RBAC configuration:

```bash
kubectl apply -f rbac

clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-binding created
clusterrolebinding.rbac.authorization.k8s.io/cluster-edit-binding created
clusterrolebinding.rbac.authorization.k8s.io/cluster-view-binding created
```

## GKE Configuration

G Suite group is configured in [gke_cluster](../../modules/gke_cluster/main.tf) Terraform module:

```ruby
  # Allow to grant RBAC roles to the members of G Suite group
  authenticator_groups_config {
    # Group name must be in format gke-security-groups@org_domain.com.
    security_group = "gke-security-groups@${var.org_domain}"
  }
```
