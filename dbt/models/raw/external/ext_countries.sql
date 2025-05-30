{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-countries.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            abbreviationTwo STRING,
            abbreviationThree STRING,
            countryNoun STRING,
            countryAdjective STRING,
            continentId STRING
         "
    }
) }}

select * from external
