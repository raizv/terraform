#!/bin/sh
set -o nounset -o errexit
cd `dirname $0`

CLUSTER_NAME=$1
PROJECT=$2
REGION=$3

# Getting cluster credentials
gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT} --region ${REGION}

echo "Applying Pod Security Policies"
kubectl apply -f ./kube/psp
