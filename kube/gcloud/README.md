# [gcloud sdk](https://cloud.google.com/sdk/docs/downloads-docker)

This is a tool builder to simply invoke `gcloud` commands.

## Building this image

To build this builder run the following command in this directory:

```bash
gcloud builds submit
```

## Usage

```yaml
- id: get-credentials
  name: gcr.io/$PROJECT_ID/gcloud
  entrypoint: bash
  args:
  - -c
  - |
    gcloud beta secrets versions access latest --secret=nexus-credentials > settings.xml
```
