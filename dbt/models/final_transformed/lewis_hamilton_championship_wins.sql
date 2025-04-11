{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_championship_wins') }}
WHERE driver_id = 'lewis-hamilton'