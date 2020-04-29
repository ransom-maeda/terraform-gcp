provider "google" {
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_id
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_service_account" "deployer" {
 account_id   = var.deployer_account_id
 display_name = "Project Deployment Service Account"
 project      = google_project.project.project_id
}

resource "google_project_iam_member" "deployer_owner" {
 role   = "roles/owner"
 member = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_storage_bucket_iam_member" "deployer_terraform_state" {
 bucket = "${var.org_short_prefix}-terraform-state-${var.environment}"
 role   = "roles/storage.objectAdmin"
 member = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_project_service" "service" {
  for_each           = toset(var.project_apis)
  service            = each.key
  project            = google_project.project.project_id
  disable_on_destroy = false
}

