{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-grands-prix.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            name STRING,
            fullName STRING,
            shortName STRING,
            abbreviation STRING,
            countryId STRING,
            totalRacesHeld INT64
         "
    }
) }}

select * from external