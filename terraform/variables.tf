variable "credentials" {
  description = "My Credentials"
  default     = "~/.google/credentials/terraform_credentials.json"
  type        = string
}

variable "gcp_project" {
  description = "Google Cloud project ID"
  type        = string
  default     = "compact-arc-447521-f9"
}

variable "gcp_region" {
  description = "Region for GCP resources"
  type        = string
  default     = "us-west1"
}

variable "kestra_service_account" {
  description = "Service account email for Kestra"
  type        = string
  default     = "terraform-runner@compact-arc-447521-f9.iam.gserviceaccount.com"
}

variable "dbt_service_account" {
  description = "Service account email for dbt"
  type        = string
  default     = "terraform-runner@compact-arc-447521-f9.iam.gserviceaccount.com"
}

variable "spark_service_account" {
  description = "Service account email for Spark"
  type        = string
  default     = "terraform-runner@compact-arc-447521-f9.iam.gserviceaccount.com"
}

variable "looker_service_account" {
  description = "Service account email for Looker"
  type        = string
  default     = "terraform-runner@compact-arc-447521-f9.iam.gserviceaccount.com"
}