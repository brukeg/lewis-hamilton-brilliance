terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "google" {
  credentials = file(var.credentials)
  project = var.gcp_project
  region  = var.gcp_region
}

# Google Cloud Storage for Raw Data
resource "google_storage_bucket" "data_lake" {
  name          = "${var.gcp_project}-data-lake"
  location      = var.gcp_region
  force_destroy = true

  uniform_bucket_level_access = true
}

# BigQuery Dataset for Semi-Processed Data
resource "google_bigquery_dataset" "semi_processed" {
  dataset_id  = "semi_processed"
  project     = var.gcp_project
  location    = var.gcp_region
}

# BigQuery Dataset for Final Transformations (Used by Looker)
resource "google_bigquery_dataset" "final" {
  dataset_id  = "final_transformed"
  project     = var.gcp_project
  location    = var.gcp_region
}

# BigQuery Dataset for Kestra Repository
resource "google_bigquery_dataset" "kestra_repo" {
  dataset_id  = "kestra_repository"
  project     = var.gcp_project
  location    = var.gcp_region
}

# IAM Permissions for Kestra, dbt, and Spark
resource "google_project_iam_member" "kestra_bq_access" {
  project = var.gcp_project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.kestra_service_account}"
}

resource "google_project_iam_member" "kestra_gcs_access" {
  project = var.gcp_project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${var.kestra_service_account}"
}

resource "google_project_iam_member" "dbt_bq_access" {
  project = var.gcp_project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.dbt_service_account}"
}

resource "google_project_iam_member" "spark_bq_access" {
  project = var.gcp_project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.spark_service_account}"
}

resource "google_project_iam_member" "looker_bq_access" {
  project = var.gcp_project
  role    = "roles/bigquery.viewer"
  member  = "serviceAccount:${var.looker_service_account}"
}
