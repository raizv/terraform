FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine

RUN gcloud components install beta

ENV PATH=/google-cloud-sdk/bin/:$PATH

ENTRYPOINT ["/google-cloud-sdk/bin/gcloud"]
