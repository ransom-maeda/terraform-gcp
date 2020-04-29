#!/bin/bash

set -e

ROOT_DIR=/root/terraform-gcp
source $ROOT_DIR/configs/gcp.env

# Authenticate gcloud client
gcloud auth login

# Create new project and set as default
gcloud projects create ${TF_ADMIN} \
	--organization ${TF_VAR_org_id} \
	--set-as-default

# Link project to billing account
gcloud beta billing projects link ${TF_ADMIN} \
	--billing-account ${TF_VAR_billing_account}

# Create terraform service account
gcloud iam service-accounts create terraform \
	--display-name "Terraform Service Account"

# Create service account key
gcloud iam service-accounts keys create ${TF_CREDS} \
	--iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

# Grant the service account permission to view the Admin Project and manage Cloud Storage
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/storage.admin

# Enable required APIs
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com

# Grant the service account permission to create projects and assign billing accounts
gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
	--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
	--role roles/billing.user

# Create the remote backend bucket in Cloud Storage and enable versioning
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}
gsutil versioning set on gs://${TF_ADMIN}

# Set backend for terraform tfstate file
cat > $ROOT_DIR/workspace/backend.tf << EOF
terraform {
 backend "gcs" {
    bucket  = "${TF_ADMIN}"
       prefix  = "terraform/state"
        }
}
EOF

# Configure your environment for the Google Cloud Terraform provider
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_ADMIN}

# Go to terraform workspace
cd $ROOT_DIR/workspace

# Iniitalize terraform
terraform init

# Plan
terraform plan --var-file=tfvars/${PROJECT_NAME}.tfvars

# Apply
terraform apply --var-file=tfvars/${PROJECT_NAME}.tfvars \
	-input=false -auto-approve
