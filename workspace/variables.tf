variable "project_name" {
  type = string
}

variable "billing_account" {
  type = string
}

variable "org_id" {
  type = string
}

variable "project_id" {
  type = string
}

variable "project_apis" {
  type = list
  description = "List of APIs to enable in project"
  default     = []
}

variable "deployer_account_id" {
  type = string
}