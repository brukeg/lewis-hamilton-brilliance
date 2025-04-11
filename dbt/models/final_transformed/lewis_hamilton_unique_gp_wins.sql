{{ config(materialized='table') }}

SELECT *
FROM {{ source('semi_processed', 'driver_unique_gp_wins') }}
WHERE driver_id = 'lewis-hamilton'
