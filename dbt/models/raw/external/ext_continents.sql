{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-continents.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            id STRING,
            abbreviation STRING,
            continentNoun STRING,
            continentAdjective STRING
         "
    }
) }}

select * from external
