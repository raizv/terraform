# [Helm](https://docs.helm.sh/) tool builder

## Building this builder

To build this [builder](https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/helm), run the following command in this directory:

```bash
gcloud builds submit
```

## Using Helm

Add the following block to your `cloudbuild.yaml` file to render kubernetes manifests and save the output to a current directory:

```yaml
steps:
"helm-chart" directory
- id: template
  name: gcr.io/$PROJECT_ID/helm
  args:
  - template
  - '.'
  - --output-dir=.
  - --values=development.yaml
  - --set=projectId=$PROJECT_ID
  - --set=appVersion=${_VERSION}
```
