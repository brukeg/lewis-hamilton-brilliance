{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-races-free-practice-2-results.csv",
         "format": "csv",
         "skip_leading_rows": 1
    }
) }}

select * from external
