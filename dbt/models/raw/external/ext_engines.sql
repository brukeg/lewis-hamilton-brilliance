{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-engines.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            engineManufacturerId STRING,
            name STRING,
            fullName STRING,
            capacity FLOAT64,
            configuration STRING,
            aspiration STRING
         "
    }
) }}

select * from external