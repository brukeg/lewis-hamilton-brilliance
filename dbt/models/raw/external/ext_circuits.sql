{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-circuits.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            name STRING,
            fullName STRING,
            previousNames STRING,
            type STRING,
            direction STRING,
            placeName STRING,
            countryId STRING,
            latitude FLOAT64,
            longitude FLOAT64,
            length FLOAT64,
            turns INT64,
            totalRacesHeld INT64
         "
    }
) }}

select * from external