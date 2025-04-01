variable "credentials" {
  description = "My Credentials"
  default     = "~/.google/credentials/google_credentials.json"
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
}

variable "dbt_service_account" {
  description = "Service account email for dbt"
  type        = string
}

variable "spark_service_account" {
  description = "Service account email for Spark"
  type        = string
}

variable "looker_service_account" {
  description = "Service account email for Looker"
  type        = string
}