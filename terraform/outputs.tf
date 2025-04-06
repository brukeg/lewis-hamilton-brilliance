output "gcp_project" {
  description = "The GCP project ID used for provisioning resources"
  value       = var.gcp_project
}

output "data_lake_bucket_name" {
  description = "The name of the GCS bucket used as the data lake"
  value       = google_storage_bucket.data_lake.name
}

output "data_lake_bucket_url" {
  description = "The URL of the GCS data lake bucket"
  value       = google_storage_bucket.data_lake.url
}

output "bigquery_dataset_final" {
  description = "The BigQuery dataset for final transformed data"
  value       = google_bigquery_dataset.final.dataset_id
}

output "bigquery_dataset_kestra_repo" {
  description = "The BigQuery dataset for the Kestra repository"
  value       = google_bigquery_dataset.kestra_repo.dataset_id
}

output "bigquery_dataset_semi_processed" {
  description = "The BigQuery dataset for semi-processed data"
  value       = google_bigquery_dataset.semi_processed.dataset_id
}