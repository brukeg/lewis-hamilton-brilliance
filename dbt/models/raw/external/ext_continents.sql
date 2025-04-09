{{ config(
    materialized='external',
    external = {
         "location": "gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-continents.csv",
         "format": "csv",
         "skip_leading_rows": 1,
         "schema": "
            continent STRING,
            abbreviation STRING,
            continent_noun STRING,
            continentAdjective STRING
         "
    }
) }}

select * from external
