# lewis-hamilton-brilliance
Data Engineering Zoomcamp Capstone Project: The Brilliance of Lewis Hamilton in data

# Problem

# project structure
```
lewis-hamilton-career-brilliance/
│── .gitignore
│── README.md
│── docker-compose.yml          # Multi-container setup for Spark, Kestra, dbt, Terraform, etc.
│── requirements.txt            # Python dependencies
│
├── config/                     # TO-DO: Configuration files for various tools if need be
│   ├── kestra/                # Kestra workflow configurations
│   ├── dbt/                   # dbt profile and connection configurations
│   ├── terraform/             # Terraform variable and provider configuration files
│   ├── spark/                 # Spark configuration files (spark-env.sh, spark-defaults.conf)
│   └── gcs/                   # GCS-related settings (if any)
│
├── data/                       # Local data storage (before uploading to GCS)
│   ├── raw/                   # Extracted CSVs from the downloaded ZIP file
│   ├── processed/             # Semi-processed files (maybe my staging layer)
│   └── final/                 # Final, cleaned/filtered data (maybe my ready for analytics layer)
│
├── dags/                       # Kestra workflow definitions (YAML files)
│   ├── ingest_f1_data.yaml    # Workflow for downloading, unzipping, and uploading raw data
│   ├── process_data.yaml      # Workflow for processing raw data (via Spark)
│   └── transform_data.yaml    # Workflow for transforming data with dbt (and materializing raw data)
│
├── terraform/                  # Terraform Infrastructure as Code (IaC)
│   ├── main.tf                # GCP infra definitions (BigQuery datasets, GCS bucket, IAM policies)
│   ├── variables.tf           # Variable definitions (gcp_project, service account emails, etc.)
│   └── outputs.tf             # Output definitions for the created resources (maybe)
│
├── ingestion/                  # Ingestion scripts for raw data
│   ├── extract_data.py        # Script to unzip and extract CSVs from the downloaded ZIP file
│   ├── upload_to_gcs.py       # Script to upload raw data from local disk to GCS bucket
│   └── spark_job.py           # Script to trigger Apache Spark batch processing
│
├── dbt/                        # dbt project for transformation and modeling
│   ├── models/                # dbt models
│   │   ├── staging/           # Staging models (semi-processed data)
│   │   ├── marts/             # Final transformation models for Looker or other BI tools
│   │   └── lewis_hamilton/      # Business-specific transformations/filters on LH data
│   ├── dbt_project.yml        # dbt project configuration file
│   └── profiles.yml           # dbt profiles for connection configurations (mounted into container)
│
├── materializations/           # (Optional) Scripts to materialize raw data into BigQuery
│   ├── materialize_raw.sql    # SQL script to create materialized views or tables from raw data in BigQuery
│   └── materialize_raw.py     # (Optional) Python script alternative for materialization
│
├── looker/                     # Looker-related configurations (maybe: for documentation)
│   ├── views/                 # Looker view definitions
│   └── dashboards/            # Looker dashboard definitions
│
├── docker/                     # Docker-related configurations and Dockerfiles for services
│   ├── Dockerfile             # Main container setup
│   ├── spark/                 # Docker configs for Spark containers
│   ├── kestra/                # Docker configs for Kestra container
│   ├── dbt/                   # Docker configs for dbt container
│   └── terraform/             # Docker configs for Terraform container
│
├── scripts/                    # Utility scripts (time permitting)
│   ├── setup_env.sh           # Initializes environment variables
│   └── deploy.sh              # Automates deployment (could trigger Terraform, etc.)
│
├── notebooks/                  # Jupyter notebooks for exploratory data analysis (time permitting, not yet)
├── logs/                       # Log storage for debugging (would be excluded from version control) (time permitting, not yet)
└── tests/                      # Testing frameworks for ETL and dbt models (time permitting, not yet)
```

# Ingestion

The ingestion pipeline is responsible for downloading, extracting, and uploading F1DB CSV data to Google Cloud Storage (GCS). It also manages the local storage of raw data by retaining only the latest release to conserve disk space and control GCS costs.

## Overview

1. **Download and Extract Data:**  
   - The `ingestion/extract_data.py` script downloads the ZIP file from the F1DB release URL and saves it to a local directory.
   - It then extracts the ZIP file, placing the CSV files in the designated raw data directory (e.g., `data/raw/`).

2. **Version Management and Data Refresh:**  
   - The `ingestion/manage_raw_data.py` script orchestrates the ingestion process.
   - It parses the release version from the ZIP file URL (using a CalVer scheme like `2025.3.0`).
   - The script compares the new version with a locally stored version (kept in a `version.txt` file within the raw data directory).
   - If the new version is detected, the script clears the local raw data directory, updates it with the new data, and uploads the latest data to GCS under a specified prefix (e.g., `raw/latest/`).

3. **Uploading Data to GCS:**  
   - The `ingestion/upload_to_gcs.py` script handles recursively uploading the contents of the local raw data directory to a GCS bucket.
   - This ensures that only the latest data is persisted in the cloud.