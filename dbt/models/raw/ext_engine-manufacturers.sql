{{ config(
    materialized='external',
    location='gs://compact-arc-447521-f9-data-lake/raw/latest/f1db-engine-manufacturers.csv',
    format='csv',
    external_format='csv',
    autodetect=true,
    skip_leading_rows=1
) }}

select * from external
