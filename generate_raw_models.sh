#!/bin/bash

# Directory where the CSVs live
RAW_DATA_DIR="data/raw"

# Output directory
MODELS_DIR="dbt/models/raw"
mkdir -p "$MODELS_DIR"

# GCS bucket info
BUCKET_PATH="gs://compact-arc-447521-f9-data-lake/raw/latest"

# Loop through each CSV file
for csv_file in "$RAW_DATA_DIR"/*.csv; do
  filename=$(basename "$csv_file")
  table_with_prefix="${filename%.csv}"
  table="${table_with_prefix#f1db-}"  # Drop the 'f1db-' prefix

  # External table file
  ext_model_path="${MODELS_DIR}/ext_${table}.sql"
  cat > "$ext_model_path" <<EOF
{{ config(
    materialized='external',
    location='${BUCKET_PATH}/${filename}',
    format='csv',
    external_format='csv',
    autodetect=true,
    skip_leading_rows=1
) }}

select * from external
EOF

  # Materialized table file
  mat_model_path="${MODELS_DIR}/${table}.sql"
  cat > "$mat_model_path" <<EOF
{{ config(materialized='table') }}

select * from {{ ref('ext_${table}') }}
EOF
done

echo "✅ All raw model SQL files generated in $MODELS_DIR"
