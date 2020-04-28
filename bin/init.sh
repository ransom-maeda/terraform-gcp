#!/bin/bash

set -e

ROOT_DIR=/root/terraform-gcp
source $ROOT_DIR/configs/gcp.env

# configure environment for the google cloud terraform provider
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}

gcloud auth activate-service-account $SA_ACCOUNT_EMAIL --key-file=$TF_CREDS

# set project
gcloud config set project $GLOBAL_PROJECT_ID

# grant service account permission to view admin project and manage cloud storage
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/storage.admin

# grant service account permission to create projects and assign billing accounts
gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/billing.user

# enable API services
gcloud services enable serviceusage.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com

# link project to billing account
gcloud beta billing projects link ${TF_ADMIN} \
  --billing-account ${TF_VAR_billing_account}

# create remote backend bucket in Cloud Storage 
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}

# create storage for terraform.tfstate file
cat > /root/terraform-gcp/workspace/backend.tf << EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}"
   prefix  = "terraform/state"
 }
}
EOF

# enable versioning for the remote bucket
gsutil versioning set on gs://${TF_ADMIN}

