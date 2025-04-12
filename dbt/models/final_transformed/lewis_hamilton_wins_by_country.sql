{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_wins_by_country') }}
WHERE driver_id = 'lewis-hamilton'