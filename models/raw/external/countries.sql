{{ config(materialized='external', location='gs://{{ var("raw_data_bucket") }}/raw/latest', format='csv') }}
SELECT * FROM { source('raw', 'countries') }
