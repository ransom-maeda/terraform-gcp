#!/bin/bash

set -e

ROOT_DIR=/root/terraform-gcp
source $ROOT_DIR/configs/gcp.env

gcloud auth activate-service-account $GCP_SERVICE_ACCOUNT_EMAIL --key-file=$ROOT_DIR/access/$KEY_FILE
