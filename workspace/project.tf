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

resource "google_service_account" "ichiki_deployer" {
 count = local.ichiki_is_dev_or_prod && local.ichiki_ci_project_id != "" ? 1 : 0
 account_id  = "${local.ichiki_meta_environment}-deployer"
 display_name = "SA for deploying infra and applications within a meta-environment"
 project   = local.ichiki_ci_project_id
}

resource "google_project_iam_member" "ichiki_deployer_owner" {
 for_each = var.ichiki_deployer_service_account_email != "" ? toset(local.ichiki_project_ids) : toset([])
 project = each.value
 role  = "roles/owner"
 member = "serviceAccount:${var.ichiki_deployer_service_account_email}"
}

resource "google_storage_bucket_iam_member" "ichiki_deployer_terraform_state" {
 count = var.ichiki_deployer_service_account_email != "" ? 1 : 0 
 bucket = "${var.org_short_prefix}-terraform-state-${var.environment}"
 role  = "roles/storage.objectAdmin"
 member = "serviceAccount:${var.ichiki_deployer_service_account_email}"
}

resource "google_project_service" "service" {
  for_each = toset([
    "container.googleapis.com",
    "serviceusage.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

