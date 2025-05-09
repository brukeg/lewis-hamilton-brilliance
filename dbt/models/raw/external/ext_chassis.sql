{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-chassis.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            constructorId STRING,
            name STRING,
            fullName STRING
         "
    }
) }}

select * from external