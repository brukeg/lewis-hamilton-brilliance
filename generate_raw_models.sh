#!/bin/bash

RAW_DATA_DIR="data/raw"

EXTERNAL_DIR="dbt/models/raw/external"
MATERIALIZED_DIR="dbt/models/raw/materialized"
mkdir -p "$EXTERNAL_DIR"
mkdir -p "$MATERIALIZED_DIR"

# GCS bucket info.
BUCKET_PATH="gs://compact-arc-447521-f9-data-lake/raw/latest"

for csv_file in "$RAW_DATA_DIR"/*.csv; do
  filename=$(basename "$csv_file")
  table_with_prefix="${filename%.csv}"
  # Remove prefix 'f1db-' if present.
  table="${table_with_prefix#f1db-}"

  
  ext_model_path="${EXTERNAL_DIR}/ext_${table}.sql"
  cat > "$ext_model_path" <<EOF
{{ config(
    materialized='external',
    external = {
         "location": "${BUCKET_PATH}/${filename}",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
EOF

  
  mat_model_path="${MATERIALIZED_DIR}/${table}.sql"
  cat > "$mat_model_path" <<EOF
{{ config(materialized='table') }}

select * from {{ ref("ext_${table}") }}
EOF
done

echo "All raw model SQL files generated in ${EXTERNAL_DIR} and ${MATERIALIZED_DIR}"
