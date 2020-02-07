# Kubernetes setup

Deploy GKE cluster `production-us-west1` in `us-west1` region using Terraform Cloud.

Login to the cluster:

```bash
gcloud config set project production-b0dcb738
gcloud container clusters get-credentials production-us-west1 --region us-west1
```

## [Terraform-gcp-inra](https://bitbucket.org/clientoutlook/terraform-gcp-infra/src) repository

Deploy `kube-system` components:

```bash
cd kube
gcloud builds submit --substitutions=_CLUSTER="production-us-west1",_LOCATION="us-west1"
```

Deploy `helm` cloud builder:

```bash
cd helm
gcloud builds submit
```

Deploy `gcloud` cloud builder:

```bash
cd ../gcloud
gcloud builds submit
```

Deploy `external-dns`:

```bash
cd ../external-dns
gcloud builds submit --substitutions=_ENVIRONMENT="production",_CLUSTER="production-us-west1",_LOCATION="us-west1"
```

## [Installer](https://bitbucket.org/clientoutlook/installer/src) repository

### Switch to `development` project

```bash
gcloud config set project development-7c02bb4b
gcloud container clusters get-credentials development --region northamerica-northeast1
```

Build `edge` image:

```bash
cd edge
gcloud builds submit --substitutions=_VERSION="6.10.0.37"
```

Create IAP secret:

```bash
helm-chart/iap_credentials.sh
```

Deploy `edge` image to `development` in `northamerica-northeast1` region:

```bash
gcloud builds submit --config=helm-chart/cloudbuild.yaml --substitutions=_VERSION="6.10.0.37",_TEST_DATA="true"
```

Promote `edge` image to `production-us-west1` cluster in `us-west1`:

```bash
gcloud builds submit --config=cloudbuild.promote.yaml --substitutions=_VERSION="6.10.0.37"
```

### Switch to `production` project

```bash
gcloud config set project production-b0dcb738
gcloud container clusters get-credentials production-us-west1 --region us-west1
```

Create IAP secret:

```bash
cd edge/helm-chart
./iap_credentials.sh
```

Deploy `edge3d` image to `production-us-west1` cluster in `us-west1`:

```bash
cd edge3d/helm-chart
gcloud builds submit --substitutions=_VERSION="6.10.0.35",_ENVIRONMENT="production",_CLUSTER="production-us-west1",_LOCATION="us-west1"
```

Deploy `edge` image to `production-us-west1` cluster in `us-west1`:

```bash
cd edge/helm-chart
gcloud builds submit --substitutions=_VERSION="6.10.0.37",_ENVIRONMENT="production",_CLUSTER="production-us-west1",_LOCATION="us-west1"
```

Deploy `rendering-3d` image to `production-us-west1` cluster in `us-west1`:

```bash
cd 3d-rendering/helm-chart
gcloud builds submit --substitutions=_VERSION="6.10.0.32",_ENVIRONMENT="production",_CLUSTER="production-us-west1",_LOCATION="us-west1"
```
