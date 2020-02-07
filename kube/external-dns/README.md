# External-DNS

[ExternalDNS](https://github.com/kubernetes-sigs/external-dns) synchronizes exposed Kubernetes Services and Ingresses with DNS providers. In a broader sense, ExternalDNS allows you to control DNS records dynamically via Kubernetes resources in a DNS provider-agnostic way.

## Deploy

Run `gcloud build` to deploy `external-dns` controller in a cluster:

```bash
# development
gcloud builds submit

# production
gcloud builds submit --substitutions=_ENVIRONMENT="production",_CLUSTER="production",_LOCATION="us-east1"
```
