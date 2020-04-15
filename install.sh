#!/bin/sh
# GCP Organization Id
TF_ORG_ID=1000290361518

# Project Id where to create Terraform service account
TF_PROJECT_ID=infrastructure-260119

# Login to GCP
gcloud auth login

# Set default project
gcloud config set project ${TF_PROJECT_ID}

# Create service account for Terraform
gcloud iam service-accounts create terraform --display-name "Terraform service account"

# Create access key for Terraform service account
gcloud iam service-accounts keys create terraform.json \
  --iam-account $(gcloud iam service-accounts list|grep terraform|awk '{print $2}')

# Assign Owner role on Terraform service account
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member "serviceAccount:terraform@$(gcloud config get-value project).iam.gserviceaccount.com" \
  --role roles/owner

# Allow Terraform service account to create projects
gcloud organizations add-iam-policy-binding ${TF_ORG_ID} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

# Allow Terraform service account to create folders
gcloud organizations add-iam-policy-binding ${TF_ORG_ID} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.folderCreator

# Allow Terraform service account to link billing account to projects
gcloud organizations add-iam-policy-binding ${TF_ORG_ID} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/billing.user

# Enable Project Services
gcloud services enable cloudresourcemanager.googleapis.com                                                                                           12:52 Tue  03 Dec 
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.co
