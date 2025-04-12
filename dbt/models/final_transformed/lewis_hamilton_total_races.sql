{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'race_participation_counts') }}
WHERE driver_id = 'lewis-hamilton'
